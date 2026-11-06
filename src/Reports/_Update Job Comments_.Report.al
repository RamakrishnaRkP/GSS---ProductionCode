report 60182 "Update Job Comments"
{
    Caption = 'Update Job-Reopen Comments';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Job Comment")
                {
                    field(Comment; Comments)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                    }
                }
            }
        }
    }
    var Comments: Text[80];
}
