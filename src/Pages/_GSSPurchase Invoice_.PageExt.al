pageextension 60123 "GSSPurchase Invoice" extends "Purchase Invoice"
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
        addbefore("VAT Bus. Posting Group")
        {
            field("GSSGen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("GSSVendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
