pageextension 60191 "JOB WIP GL Entries Ext" extends "Job WIP G/L Entries"
{
    actions
    {
        addafter("&Navigate")
        {
            action(TestDelete)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    JobWIPGLEntry: Record "Job WIP G/L Entry";
                begin
                    JobWIPGLEntry.SetCurrentKey("Job No.", Reversed, "Job Complete");
                    JobWIPGLEntry.SetFilter("Job No.", '=%1', 'DXB-SO-2022-00264');
                    JobWIPGLEntry.SetRange("Job Complete", false);
                    if JobWIPGLEntry.FindSet()then begin
                        JobWIPGLEntry.DeleteAll();
                    end;
                end;
            }
        }
    }
}
