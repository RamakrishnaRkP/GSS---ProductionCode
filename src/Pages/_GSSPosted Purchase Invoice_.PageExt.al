pageextension 60137 "GSSPosted Purchase Invoice" extends "Posted Purchase Invoice"
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
        ////Rk
        addafter("Buy-from Vendor Name")
        {
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
