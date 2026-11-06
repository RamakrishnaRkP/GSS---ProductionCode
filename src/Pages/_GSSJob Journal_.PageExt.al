pageextension 60152 "GSSJob Journal" extends "Job Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
            }
        }
        modify(Control1)
        {
            Editable = AllowJobJnlUpdate;
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId)then AllowJobJnlUpdate:=UserSetup."GSSAllow Job Jnl Update";
    end;
    var AllowJobJnlUpdate: Boolean;
}
