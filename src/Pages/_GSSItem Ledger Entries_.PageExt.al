pageextension 60154 "GSSItem Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Serial No.")
        {
            field("GSSItem Tracking"; Rec."Item Tracking")
            {
                ApplicationArea = All;
            }
        }
    }
}
