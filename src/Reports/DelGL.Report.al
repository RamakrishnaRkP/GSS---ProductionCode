report 60124 DelGL
{
    Caption = 'Delete GL Test';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry"=RIMD;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Document Type", "Document No.", "Posting Date", "Entry No.";

            trigger OnAfterGetRecord()
            begin
                "G/L Entry".Delete();
            end;
        }
    }
}
