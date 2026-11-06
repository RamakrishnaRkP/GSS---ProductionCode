pageextension 60129 "GSSItem Card" extends "Item Card"
{
    layout
    {
        modify("Manufacturing Policy")
        {
            Visible = true;
        }
        addlast("Posting Details")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
