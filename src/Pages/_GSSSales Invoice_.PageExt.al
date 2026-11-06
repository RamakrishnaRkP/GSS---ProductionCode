pageextension 60140 "GSSSales Invoice" extends "Sales Invoice"
{
    layout
    {
        addafter("External Document No.")
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
                Visible = false;
                ApplicationArea = All;
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("GSSCustomer Posting Group"; Rec."Customer Posting Group")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
}
