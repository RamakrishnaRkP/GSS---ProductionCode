report 60125 DelProjWIPGL
{
    Caption = 'Modify Approval Entry';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Approval Entry"=RIMD;

    dataset
    {
        dataitem("Approval Entry"; "Approval Entry")
        {
            RequestFilterFields = "Entry No.";

            trigger OnAfterGetRecord()
            begin
                if Open then "Approval Entry".Validate(Status, "Approval Entry".Status::Open);
                if Reject then "Approval Entry".Validate(Status, "Approval Entry".Status::Rejected);
                "Approval Entry".Modify();
            end;
            trigger OnPreDataItem()
            begin
            //"Approval Entry".SetFilter("Entry No.", '%1', 46120);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Reject; Reject)
                    {
                        ApplicationArea = All;
                    }
                    field(Open; Open)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var Reject: Boolean;
    Open: Boolean;
}
