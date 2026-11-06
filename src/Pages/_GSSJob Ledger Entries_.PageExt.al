pageextension 60118 "GSSJob Ledger Entries" extends "Job Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
