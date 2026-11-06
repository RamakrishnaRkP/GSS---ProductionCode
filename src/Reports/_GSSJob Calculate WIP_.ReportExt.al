reportextension 60103 "GSSJob Calculate WIP" extends "Job Calculate WIP"
{
    dataset
    {
        modify(Job)
        {
        trigger OnAfterAfterGetRecord()
        var
            myInt: Integer;
            Job2: Record Job;
        begin
            if Job.Complete then CalWIPEntriesCU.CalcRecogSalesEntries(Job);
            if Job2.Get(Job."No.")then begin
                Job2."GSSWIP Calc. Required":=false;
                Job2.Modify(false);
            end;
        end;
        }
    }
    requestpage
    {
        layout
        {
        }
    }
    trigger OnPostReport()
    var
        JobRec: Record Job;
        Job2: Record Job;
    begin
    /*
        JobRec.CopyFilters(Job);
        if JobRec.FindFirst() then
            repeat
                Clear(JobComplete);

                Job2.Get(JobRec."No.");

                JobComplete := Job2.Complete;// and (WIPPostingDate >= Job2."Ending Date");

                if JobComplete then
                    CalcRecogSalesEntries(Job2);
            until JobRec.Next() = 0;
        */
    end;
    // local procedure CreateRecogSalesEntry(var JobTask: Record "Job Task")
    // var
    //     WIPEntries: Record "Job WIP Entry";
    //     LastWipEntryNo: Integer;
    //     ReverseWipEntry: Record "Job WIP Entry";
    // begin
    //     if WIPEntries.FindLast() then
    //         LastWipEntryNo := WIPEntries."Entry No.";
    //     Clear(WIPEntries);
    //     WIPEntries.Reset();
    //     WIPEntries.SetCurrentKey("Entry No.");
    //     WIPEntries.SetRange("Job No.", Job."No.");
    //     WIPEntries.SetRange("G/L Account No.", '41101');
    //     if WIPEntries.FindFirst() then begin
    //         ReverseWipEntry := WIPEntries;
    //         ReverseWipEntry."Entry No." := LastWipEntryNo + 1;
    //         ReverseWipEntry."WIP Entry Amount" := JobTask."Recognized Sales Amount";
    //         ReverseWipEntry.Validate("Global Dimension 1 Code", JobTask."Global Dimension 1 Code");
    //         ReverseWipEntry.Insert();
    //     end;
    // end;
    var JobComplete: Boolean;
    CalWIPEntriesCU: Codeunit "GSSCalc WIP Entries";
}
