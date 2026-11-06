report 60126 ModifyProjWIPGL
{
    Caption = 'Modify Proj Wip GL Entry - Reverse';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Job WIP G/L Entry"=RIMD;

    dataset
    {
        dataitem("Job WIP G/L Entry"; "Job WIP G/L Entry")
        {
            RequestFilterFields = "Document No.", Type, Reverse;

            trigger OnAfterGetRecord()
            begin
                if Reverse then Reverse:=false
                else if not Reverse then Reverse:=true;
                "Job WIP G/L Entry".Modify();
            end;
        }
    }
}
