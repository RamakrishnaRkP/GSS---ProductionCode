pageextension 60164 "Job G/L Journal Ext" extends "Job G/L Journal"
{
    layout
    {
        addafter(Description)
        {
            field("ATOS Narration"; Rec."ATOS Narration")
            {
                ApplicationArea = All;
            }
        }
    }
}
