pageextension 60143 "GSSSales Credit Memo" extends "Sales Credit Memo"
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
