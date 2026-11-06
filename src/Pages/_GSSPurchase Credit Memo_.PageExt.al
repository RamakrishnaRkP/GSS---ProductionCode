pageextension 60133 "GSSPurchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
}
