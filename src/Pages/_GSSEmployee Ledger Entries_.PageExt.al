pageextension 60105 "GSSEmployee Ledger Entries" extends "Employee Ledger Entries"
{
    layout
    {
        addlast(Group)
        {
            field("GSSHR Integration Entry"; Rec."GSSHR Integration Entry")
            {
                ApplicationArea = All;
            }
        }
    }
}
