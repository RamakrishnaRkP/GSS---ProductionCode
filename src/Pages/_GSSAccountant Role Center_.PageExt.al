pageextension 60161 "GSSAccountant Role Center" extends "Accountant Role Center"
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
