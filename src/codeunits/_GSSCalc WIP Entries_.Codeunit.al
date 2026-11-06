codeunit 60117 "GSSCalc WIP Entries"
{
    trigger OnRun()
    begin
    end;
    procedure CalcRecogSalesEntries(var Job: Record Job)
    var
        CalcWIPEntries: Codeunit "GSSCalc WIP Entries";
        JobTasks: Record "Job Task";
        JobWIPEntries: Record "Job WIP Entry";
        JobWIPTotal: Record "Job WIP Total";
        JobWIPMethod: Record "Job WIP Method";
        JobTask2: Record "Job Task";
    begin
        if not Job.Complete then exit;
        if not ReverseRecognizedSalesWIPEntries(Job)then exit;
        Clear(JobTasks);
        JobTasks.SetCurrentKey("Job No.", "Job Task No.");
        JobTasks.SetRange("Job No.", Job."No.");
        JobTasks.SetFilter("Recognized Sales G/L Amount", '<>%1', 0);
        if JobTasks.FindFirst()then repeat InsertRecognizedSalesEntry(Job, JobTasks);
            until JobTasks.Next() = 0;
    end;
    local procedure ReverseRecognizedSalesWIPEntries(var Job: Record Job): Boolean var
        WIPEntries: Record "Job WIP Entry";
        LastWipEntryNo: Integer;
        ReverseWipEntry: Record "Job WIP Entry";
        EntriesReversed: Boolean;
        WipEntry: Record "Job WIP Entry";
        Int: Record Integer temporary;
    begin
        if WIPEntries.FindLast()then LastWipEntryNo:=WIPEntries."Entry No.";
        Clear(WIPEntries);
        WIPEntries.Reset();
        WIPEntries.SetCurrentKey("Entry No.");
        WIPEntries.SetRange("Job No.", Job."No.");
        WIPEntries.SetFilter("G/L Account No.", GetSalesRecognizedGLAccounts());
        //ITOS-TS-10-Nov-22-
        //removed below filter to reverse all reconginized sales lines
        //recongized sales lines will be created for job task wise.
        //WIPEntries.SetRange("Global Dimension 1 Code", '');
        //ITOS-TS-10-NOV-22
        if WIPEntries.FindFirst()then repeat Int.Init();
                Int.Number:=WIPEntries."Entry No.";
                Int.Insert();
            until WIPEntries.Next() = 0;
        if Int.FindFirst()then repeat if WipEntry.Get(Int.Number)then begin
                    ReverseWipEntry:=WipEntry;
                    ReverseWipEntry."Entry No.":=LastWipEntryNo + 1;
                    ReverseWipEntry."WIP Entry Amount":=ReverseWipEntry."WIP Entry Amount" * -1;
                    ReverseWipEntry.Insert();
                    EntriesReversed:=true;
                    LastWipEntryNo:=ReverseWipEntry."Entry No.";
                end;
            until Int.Next() = 0;
        exit(EntriesReversed)end;
    local procedure GetSalesRecognizedGLAccounts(): Text var
        GLAccounts: Text;
        JobPostingGroup: Record "Job Posting Group";
    begin
        JobPostingGroup.SetCurrentKey(Code);
        JobPostingGroup.SetFilter("Recognized Sales Account", '<>%1', '');
        if JobPostingGroup.FindFirst()then repeat if GLAccounts <> '' then GLAccounts+='|';
                GLAccounts+=JobPostingGroup."Recognized Sales Account";
            until JobPostingGroup.Next() = 0;
        exit(GLAccounts);
    end;
    local procedure InsertRecognizedSalesEntry(var Job: Record Job; var JobTask: Record "Job Task")
    var
        WIPEntries: Record "Job WIP Entry";
        LastWipEntryNo: Integer;
        NewWipEntry: Record "Job WIP Entry";
        JobPostingGroup: Record "Job Posting Group";
        DimMgt: Codeunit DimensionManagement;
    begin
        JobTask.TestField("Job Posting Group");
        if WIPEntries.FindLast()then LastWipEntryNo:=WIPEntries."Entry No.";
        JobPostingGroup.Get(JobTask."Job Posting Group");
        JobPostingGroup.TestField("Recognized Sales Account");
        Clear(WIPEntries);
        WIPEntries.Reset();
        WIPEntries.SetCurrentKey("Entry No.");
        WIPEntries.SetRange("Job No.", Job."No.");
        WIPEntries.SetRange(Type, WIPEntries.Type::"Recognized Sales");
        //WIPEntries.SetRange("G/L Account No.", JobPostingGroup."Recognized Sales Account");
        //WIPEntries.SetRange("Job Posting Group", JobPostingGroup.Code);
        if WIPEntries.FindFirst()then begin
            NewWipEntry:=WIPEntries;
            NewWipEntry."Entry No.":=LastWipEntryNo + 1;
            NewWipEntry."WIP Entry Amount":=JobTask."Recognized Sales G/L Amount" * -1;
            NewWipEntry.Validate("Job Posting Group", JobTask."Job Posting Group");
            NewWipEntry.Validate("G/L Account No.", JobPostingGroup."Recognized Sales Account");
            NewWipEntry.Validate("G/L Bal. Account No.", JobPostingGroup."Job Sales Adjustment Account");
            NewWipEntry.Validate("Global Dimension 1 Code", JobTask."Global Dimension 1 Code");
            NewWipEntry.Validate("Dimension Set ID", GetJobTaskDimensionSetID(JobTask));
            NewWipEntry.Insert();
            //DimMgt.UpdateGlobalDimFromDimSetID(NewWipEntry."Dimension Set ID", NewWipEntry."Global Dimension 1 Code", NewWipEntry."Global Dimension 2 Code");
            LastWipEntryNo:=NewWipEntry."Entry No.";
        end;
    end;
    local procedure GetJobTaskDimensionSetID(var JobTask: Record "Job Task"): Integer var
        myInt: Integer;
        JobTaskDimension: Record "Job Task Dimension";
        TempDimensionBuffer: Record "Dimension Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimSetId: Integer;
    begin
        TempDimensionBuffer.Reset();
        TempDimensionBuffer.DeleteAll();
        JobTaskDimension.SetRange("Job No.", JobTask."Job No.");
        JobTaskDimension.SetRange("Job Task No.", JobTask."Job Task No.");
        if JobTaskDimension.FindSet then repeat TempDimensionBuffer."Dimension Code":=JobTaskDimension."Dimension Code";
                TempDimensionBuffer."Dimension Value Code":=JobTaskDimension."Dimension Value Code";
                TempDimensionBuffer.Insert();
            until JobTaskDimension.Next() = 0;
        if not DimMgt.CheckDimBuffer(TempDimensionBuffer)then Error(DimMgt.GetDimCombErr);
        //TempJobWIPBuffer[1]."Dim Combination ID" := DimMgt.CreateDimSetIDFromDimBuf(TempDimensionBuffer);
        DimSetId:=DimMgt.CreateDimSetIDFromDimBuf(TempDimensionBuffer);
        exit(DimSetId);
    end;
    procedure CreateJobWIPTotal(var JobTask: Record "Job Task"; var JobWIPTotal: Record "Job WIP Total"; WIPPostingDate: Date)
    var
    begin
        JobWIPTotalChanged:=true;
        WIPAmount:=0;
        RecognizedAllocationPercentage:=0;
        JobWIPTotal.Init();
        if JobTask.Find('-')then repeat if JobTask."Job Task Type" = JobTask."Job Task Type"::Posting then begin
                    JobTask.CalcFields("Schedule (Total Cost)", "Schedule (Total Price)", "Usage (Total Cost)", "Usage (Total Price)", "Contract (Total Cost)", "Contract (Total Price)", "Contract (Invoiced Price)", "Contract (Invoiced Cost)");
                    JobWIPTotal."Schedule (Total Cost)"+=JobTask."Schedule (Total Cost)";
                    JobWIPTotal."Schedule (Total Price)"+=JobTask."Schedule (Total Price)";
                    JobWIPTotal."Usage (Total Cost)"+=JobTask."Usage (Total Cost)";
                    JobWIPTotal."Usage (Total Price)"+=JobTask."Usage (Total Price)";
                    JobWIPTotal."Contract (Total Cost)"+=JobTask."Contract (Total Cost)";
                    JobWIPTotal."Contract (Total Price)"+=JobTask."Contract (Total Price)";
                    JobWIPTotal."Contract (Invoiced Price)"+=JobTask."Contract (Invoiced Price)";
                    JobWIPTotal."Contract (Invoiced Cost)"+=JobTask."Contract (Invoiced Cost)";
                //ITOS OnCreateJobWIPTotalOnAfterUpdateJobWIPTotal(JobTask, JobWIPTotal);
                end;
            until JobTask.Next() = 0;
        // Get values from the "WIP-Total"::Total Job Task, which always is the last entry in the range:
        JobWIPTotal."Job No.":=JobTask."Job No.";
        JobWIPTotal."Job Task No.":=JobTask."Job Task No.";
        JobWIPTotal."WIP Posting Date":=WIPPostingDate;
        JobWIPTotal."WIP Posting Date Filter":=CopyStr(JobTask.GetFilter("Posting Date Filter"), 1, MaxStrLen(JobWIPTotal."WIP Posting Date Filter"));
        JobWIPTotal."WIP Planning Date Filter":=CopyStr(JobTask.GetFilter("Planning Date Filter"), 1, MaxStrLen(JobWIPTotal."WIP Planning Date Filter"));
        JobWIPTotal."WIP Method":=JobTask."WIP Method";
        JobWIPTotal.Insert();
    end;
    procedure CalcRecognizedSales(var JobTask: Record "Job Task"; JobWIPTotal: Record "Job WIP Total"; JobWIPMethod: Record "Job WIP Method")
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        //OnBeforeCalcRecognizedSales(JobTask, JobWIPTotal, JobWIPMethod, IsHandled);
        if IsHandled then exit;
        with JobWIPMethod do case "Recognized Sales" of // "Recognized Sales"::"Contract (Invoiced Price)":
            //     CalcContractInvoicedPrice(JobTask);
            // "Recognized Sales"::"Usage (Total Cost)":
            //     CalcUsageTotalCostSales(JobTask);
            // "Recognized Sales"::"Usage (Total Price)":
            //     CalcUsageTotalPrice(JobTask);
            // "Recognized Sales"::"Percentage of Completion":
            //     CalcPercentageofCompletion(JobTask, JobWIPTotal);
            "Recognized Sales"::"Sales Value": CalcSalesValue(JobTask, JobWIPTotal);
            end;
    end;
    procedure CalcSalesValue(var JobTask: Record "Job Task"; JobWIPTotal: Record "Job WIP Total")
    begin
        if JobWIPTotal."Schedule (Total Price)" = 0 then exit;
        JobTask.CalcFields("Schedule (Total Cost)", "Schedule (Total Price)", "Usage (Total Cost)", "Usage (Total Price)", "Contract (Total Cost)", "Contract (Total Price)", "Contract (Invoiced Price)", "Contract (Invoiced Cost)");
        if JobWIPTotalChanged then begin
            WIPAmount:=(JobWIPTotal."Usage (Total Price)" * JobWIPTotal."Contract (Total Price)" / JobWIPTotal."Schedule (Total Price)") - JobWIPTotal."Contract (Invoiced Price)";
            if JobWIPTotal."Usage (Total Price)" <> 0 then RecognizedAllocationPercentage:=WIPAmount / JobWIPTotal."Usage (Total Price)";
        end;
        with JobTask do begin
            if RecognizedAllocationPercentage <> 0 then WIPAmount:=Round("Usage (Total Price)" * RecognizedAllocationPercentage);
            "Recognized Sales Amount":=("Contract (Invoiced Price)" + WIPAmount);
        end;
    end;
    var RecognizedAllocationPercentage: Decimal;
    WIPAmount: Decimal;
    JobWIPTotalChanged: Boolean;
}
