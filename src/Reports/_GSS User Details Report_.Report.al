report 60104 "GSS User Details Report"
{
    ApplicationArea = All;
    Caption = 'User Permission Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/User Details.rdl';

    dataset
    {
        dataitem(User; User)
        {
            RequestFilterFields = "User Name";

            column(UserName; "User Name")
            {
            }
            column(Department; UserSetup."GSSDepartment Code")
            {
            }
            dataitem("Access Control"; "Access Control")
            {
                DataItemLink = "User Security ID"=field("User Security ID");

                column(DashboardRole; UserPersonalization."Profile ID")
                {
                }
                column(Role_Name; PermissionName)
                {
                }
                column(Company_Name; "Access Control"."Company Name")
                {
                }
                dataitem(Integer; Integer)
                {
                    column(User_Group_Code;'')
                    {
                    } //UserGroupAccessControl."User Group Code") { }
                    trigger OnAfterGetRecord()
                    begin
                    // UserGroupAccessControl.Next();
                    //if UserGroupAccessControl.Next() = 0 then
                    //  CurrReport.Break();
                    end;
                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, AcessControlCount);
                    end;
                }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(PermissionName);
                    //for some reasons, PerSet.GET returns false if the permission set is created for the extension
                    //for Example, ATOS BASE APP or GSS, and due to this the name becomes blank.
                    //to avoid confusion, if the permission set is not found by the role id,
                    //we are setting the name to the Role ID
                    //if not PerSet.Get("Access Control"."Role ID") then;
                    //     PerSet.Name := "Access Control"."Role ID";
                    "Access Control".CalcFields("Role Name");
                    PermissionName:="Access Control"."Role Name";
                /*  clear(UserGroupAccessControl);
                     UserGroupAccessControl.SetCurrentKey("User Group Code", "User Security ID", "Role ID", "Company Name", Scope, "App ID");
                     UserGroupAccessControl.SetRange("User Security ID", "Access Control"."User Security ID");
                     UserGroupAccessControl.SetRange("Role ID", "Access Control"."Role ID");
                     UserGroupAccessControl.SetRange("Company Name", "Access Control"."Company Name");
                     AcessControlCount := UserGroupAccessControl.Count; */
                //if UserGroupAccessControl.FindFirst() then;
                end;
                trigger OnPostDataItem()
                begin
                    //Clearing the permission set variable to avoid duplicate value issue
                    Clear(PermissionName);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(UserPersonalization);
                IF UserPersonalization.Get(User."User Security ID")THEN;
                Clear(UserSetup);
                if UserSetup.Get(User."User Name")then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var UserPersonalization: Record "User Personalization";
    Department1: Record "User Setup";
    PermissionName: Text[30];
    UserGroupCode: Code[20];
    // UserGroupAccessControl: Record "User Group Access Control";
    AcessControlCount: Integer;
    UserSetup: Record "User Setup";
}
