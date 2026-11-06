pageextension 60151 "GSSPosted Return Receipt" extends "Posted Return Receipt"
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
