pageextension 60145 "GSSPosted Sales Invoice" extends "Posted Sales Invoice"
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
    }
}
