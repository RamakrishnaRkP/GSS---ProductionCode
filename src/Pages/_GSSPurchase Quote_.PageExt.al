pageextension 60124 "GSSPurchase Quote" extends "Purchase Quote"
{
    layout
    {
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
