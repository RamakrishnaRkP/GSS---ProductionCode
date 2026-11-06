report 60127 ModifyProjWIPGL2
{
    Caption = 'Modify Proj Wip GL Entry - Reversed';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Job WIP G/L Entry"=RIMD;

    dataset
    {
        dataitem("Job WIP G/L Entry"; "Job WIP G/L Entry")
        {
            RequestFilterFields = "Job No.", "Document No.", Type, Reversed;

            trigger OnAfterGetRecord()
            begin
                /* if "Job WIP G/L Entry".Reversed then
                    "Job WIP G/L Entry".Reversed := false
                else
                    if not "Job WIP G/L Entry".Reversed then
                        "Job WIP G/L Entry".Reversed := true; */
                if "Job WIP G/L Entry"."Document No." = FindLatestDocumentNo("Job WIP G/L Entry")then begin
                    "Job WIP G/L Entry".Reversed:=false;
                    "Job WIP G/L Entry".Modify(true);
                end;
            end;
        }
    }
    local procedure FindLatestDocumentNo(jobwipgl: Record "Job WIP G/L Entry"): Code[20]begin
        jobwipgl.Reset();
        jobwipgl.SetCurrentKey("Posting Date");
        jobwipgl.SetRange("Job No.", jobwipgl."Job No.");
        jobwipgl.SetAscending("Posting Date", false);
        if jobwipgl.FindFirst()then exit(jobwipgl."Document No.");
    end;
}
