pageextension 60134 "GSSPurchase Order Archive" extends "Purchase Order Archive"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
