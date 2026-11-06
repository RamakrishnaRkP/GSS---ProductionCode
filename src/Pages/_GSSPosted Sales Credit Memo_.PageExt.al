pageextension 60147 "GSSPosted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("No.")
        {
            field("GSSJob No."; Rec."GSSJob No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
