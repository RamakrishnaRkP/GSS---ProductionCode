report 60168 TestWipCalc
{
    Caption = 'TestWipCalc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
    }
    trigger OnInitReport()
    var
        Job: Record Job;
    begin
        JobSetup.Get();
        UserSetup.Get(UserId);
        UserSetup.TestField("Allow Posting From");
        UserSetup.TestField("Allow Posting To");
        PostingDate:=WorkDate();
        //check if posting date is not in allowed date range, then skip auto calculation and posting
        if(PostingDate < UserSetup."Allow Posting From") OR (PostingDate > UserSetup."Allow Posting To")then exit; //PostingDate := UserSetup."Allow Posting To";
        if JobSetup."GSSAuto Calc. Job WIP" then begin
            CalculateWIPForWIPReqJobs();
        end;
        if JobSetup."GSSAuto Post Job WIP" then PostWIPForCalculatedEntries();
        //check for compeleted job and post
        // We are calculating the wip for completed jobs after WIP required entries have been posted
        // otherwise the recognized sales become zero. 
        // If auto post wip is not enabled, we will not mark the job as completed
        // because there might be some pending wip entries for the job which are not posted
        // and marking the job as completed will reverse the pending entries and calculate for compeleted 
        // which might result in 0 Recognized sales
        //********* DO NOT CHANGE THE ORDER **********************//
        //*** First normal wip to be calculated posted ***********//
        //*** Then Job to be marked as compelted *****************//
        //*** WIP to be calculated & Posted for completed Jobs ***//
        if JobSetup."GSSAuto Complete Job" and JobSetup."GSSAuto Post Job WIP" then begin
            CheckAndMarkJobAsCompleted();
            if JobSetup."GSSAuto Calc. Job WIP" then CalculateWIPForCompletedJobs();
            if JobSetup."GSSAuto Post Job WIP" then PostWIPForCalculatedEntries();
        end;
    end;
    local procedure CheckAndMarkJobAsCompleted()
    var
        Job: Record Job;
    begin
        Clear(Job);
        Job.Reset();
        Job.SetCurrentKey("No.");
        Job.SetFilter("No.", '=%1', 'PROJECT_TEST_001');
        Job.SetRange(Status, Job.Status::Open);
        if Job.FindFirst()then repeat // Message('%1 Status Changing Before Complete Job No', Job."No.");
                if(Job.PercentCompleted() = 100) and (Job.PercentInvoiced() = 100)then if Job2.Get(Job."No.")then begin
                        //   Message('%1 Status Changing After Complete Job No', Job2."No.");
                        Job2.Validate(Status, Job.Status::Completed);
                        Job2.Modify(false);
                    end;
            until Job.Next() = 0;
    end;
    local procedure CalculateWIPForWIPReqJobs()
    var
        Job: Record Job;
    begin
        Clear(JobCalculateWIP);
        Clear(Job);
        Job.Reset();
        Job.SetCurrentKey("No.");
        Job.SetFilter("No.", '=%1', 'PROJECT_TEST_001');
        Job.SetRange(Status, Job.Status::Open);
        Job.SetRange("GSSWIP Calc. Required", true);
        if Job.FindFirst()then repeat if Job2.Get(Job."No.")then CalcWIP(Job2);
            until Job.Next() = 0;
    end;
    local procedure CalculateWIPForCompletedJobs()
    var
        Job: Record Job;
    begin
        //Calculate WIP for Completed Job (Completion WIP)
        Clear(Job);
        Job.Reset();
        Job.SetCurrentKey("No.");
        Job.SetFilter("No.", '=%1', 'PROJECT_TEST_001');
        Job.SetRange("GSSWIP Calc. Required");
        Job.SetRange(Status, Job.Status::Completed);
        Job.SetRange("WIP Completion Posted", false);
        if Job.FindFirst()then repeat if Job2.Get(Job."No.")then CalcWIP(Job2);
            until Job.Next() = 0;
    end;
    local procedure PostWIPForCalculatedEntries()
    var
        Job: Record Job;
    begin
        if JobSetup."GSSAuto Post Job WIP" then begin
            // if GLSetup."Journal Templ. Name Mandatory" then begin
            //     GLSetup.TestField("Job WIP Jnl. Template Name");
            //     GLSetup.TestField("Job WIP Jnl. Batch Name");
            //     GenJnlBatch.Get(GLSetup."Job WIP Jnl. Template Name", GLSetup."Job WIP Jnl. Batch Name");
            // end;
            Clear(Job);
            Job.Reset();
            Job.SetCurrentKey("No.");
            //Removed below filter for completed jobs.
            //Job.SetRange(Status, Job.Status::Open);
            Job.SetFilter("No.", '=%1', 'PROJECT_TEST_001');
            Job.SetFilter("WIP Posting Date", '<=%1', PostingDate);
            Job.SetRange("WIP Entries Exist", true);
            if Job.FindFirst()then repeat Clear(Job2);
                    if Job2.Get(Job."No.")then PostJobWIP(Job2);
                until Job.Next() = 0;
        end;
    end;
    local procedure CalcWIP(var Job: Record Job)
    var
        DocNo: Code[20];
        NewNoSeriesCode: Code[20];
    begin
        JobSetup.TestField("Job Nos.");
        // NoSeriesMgt.InitSeries(JobSetup."Job WIP Nos.", JobSetup."Job WIP Nos.", 0D, DocNo, NewNoSeriesCode);
        if NoSeriesMgt.AreRelated(JobSetup."Job WIP Nos.", JobSetup."Job WIP Nos.")then NewNoSeriesCode:=JobSetup."Job WIP Nos.";
        DocNo:=NoSeriesMgt.GetNextNo(NewNoSeriesCode);
        JobCalculateWIP.JobCalcWIP(Job, PostingDate, DocNo);
        if Job.Complete then CalWIPEntriesCU.CalcRecogSalesEntries(Job);
        Job."GSSWIP Calc. Required":=false;
        Job.Modify(false);
    end;
    local procedure PostJobWIP(var Job: Record Job)
    var
        myInt: Integer;
        JustReverse: Boolean;
        DocNo: Code[20];
        ReplacePostDate: Boolean;
        NewNoSeriesCode: Code[20];
    begin
        JustReverse:=false;
        ReplacePostDate:=false;
        Clear(JobCalculateWIP);
        if DocNo = '' then begin
            JobSetup.TestField("Job Nos.");
            // NoSeriesMgt.InitSeries(JobSetup."Job WIP Nos.", JobSetup."Job WIP Nos.", 0D, DocNo, NewNoSeriesCode);
            if NoSeriesMgt.AreRelated(JobSetup."Job WIP Nos.", JobSetup."Job WIP Nos.")then NewNoSeriesCode:=JobSetup."Job WIP Nos.";
            DocNo:=NoSeriesMgt.GetNextNo(NewNoSeriesCode);
        end;
        // if GLSetup."Journal Templ. Name Mandatory" then begin
        //     JobCalculateWIP.SetGenJnlBatch(GenJnlBatch);
        //     DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostingDate, true);
        // end;
        JobCalculateBatches.BatchError(PostingDate, DocNo);
        JobCalculateWIP.CalcGLWIP(Job."No.", JustReverse, DocNo, PostingDate, ReplacePostDate);
    end;
    var JobWIPCalc: Report "Job Calculate WIP";
    JobWIPPostToGL: Report "Job Post WIP to G/L";
    JobSetup: Record "Jobs Setup";
    UserSetup: Record "User Setup";
    PostingDate: Date;
    NoSeriesMgt: Codeunit "No. Series";
    GLSetup: Record "General Ledger Setup";
    GenJnlBatch: Record "Gen. Journal Batch";
    JobCalculateWIP: Codeunit "Job Calculate WIP";
    JobCalculateBatches: Codeunit "Job Calculate Batches";
    Job2: Record Job;
    CalWIPEntriesCU: Codeunit "GSSCalc WIP Entries";
}
