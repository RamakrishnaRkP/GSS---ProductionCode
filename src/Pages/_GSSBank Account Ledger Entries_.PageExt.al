pageextension 60106 "GSSBank Account Ledger Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("GSSHR Integration Entry"; Rec."GSSHR Integration Entry")
            {
                ApplicationArea = All;
            }
        }
    }
}
