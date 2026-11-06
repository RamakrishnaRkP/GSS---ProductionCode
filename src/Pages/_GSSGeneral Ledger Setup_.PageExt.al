pageextension 60103 "GSSGeneral Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("GSSDefault Global Dim. 1 Value"; Rec."GSSDefault Global Dim. 1 Value")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field(JobExpiryNotificationEmail; Rec.JobExpiryNotificationEmail)
            {
                ApplicationArea = All;
            }
        }
        modify("Journal Templ. Name Mandatory")
        {
            Editable = true;
        }
    }
}
