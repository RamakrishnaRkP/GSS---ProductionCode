report 60174 UpdateUsers
{
    Caption = 'Disable Users';
    UsageCategory = Administration;
    ApplicationArea = All;
    Permissions = tabledata User=RIMD;
    ProcessingOnly = true;

    dataset
    {
        dataitem(User; User)
        {
            DataItemTableView = where("User Name"=filter('<> KISHOREK'));

            trigger OnAfterGetRecord()
            begin
                User.State:=User.State::Disabled;
                User.Modify();
            end;
            trigger OnPreDataItem()
            begin
            //User.SetFilter("User Name", '<>%1|<>%2', 'CONSULTANT', 'DEVELOPER');
            end;
        }
    }
}
