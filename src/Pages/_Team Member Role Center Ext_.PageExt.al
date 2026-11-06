pageextension 60198 "Team Member Role Center Ext" extends "Team Member Role Center"
{
    layout
    {
        addbefore(Emails)
        {
            part(Jobs; "Job Cues")
            {
                ApplicationArea = All;
            }
        }
    }
}
