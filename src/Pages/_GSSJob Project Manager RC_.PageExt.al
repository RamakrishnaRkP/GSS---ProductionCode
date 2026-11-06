pageextension 60159 "GSSJob Project Manager RC" extends "Job Project Manager RC"
{
    actions
    {
        addlast(embedding)
        {
            action(GSSSalesCommentSheet)
            {
                ApplicationArea = Jobs;
                Caption = 'Sales Comment List';
                RunObject = Page "Sales Comment List";
                RunPageMode = View;
                ToolTip = 'View or add comments for the sales documents.';
            }
        }
    }
}
