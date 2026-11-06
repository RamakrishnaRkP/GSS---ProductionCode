pageextension 60127 "GSSFixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addafter("Serial No.")
        {
            field("GSSAsset No."; Rec."GSSAsset Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
