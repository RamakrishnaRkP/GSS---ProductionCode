pageextension 60171 "FALedEntries Ext" extends "FA Ledger Entries"
{
    layout
    {
        addafter("FA No.")
        {
            field("FA Serial No."; Rec."FA Serial No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
