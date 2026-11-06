report 60128 ModifyProjWIPGL3
{
    Caption = 'Modify Proj Wip GL Entry - Job Complete';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Job WIP G/L Entry"=RIMD;

    dataset
    {
        dataitem("Job WIP G/L Entry"; "Job WIP G/L Entry")
        {
            RequestFilterFields = "Document No.", Type, "Job Complete";

            trigger OnAfterGetRecord()
            begin
                if "Job Complete" then "Job Complete":=false
                else if not "Job Complete" then "Job Complete":=true;
                "Job WIP G/L Entry".Modify(true);
            end;
        }
    }
}
