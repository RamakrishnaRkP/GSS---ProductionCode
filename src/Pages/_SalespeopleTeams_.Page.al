page 60170 "SalespeopleTeams"
{
    PageType = API;
    Caption = 'SalespeopleTeams';
    APIPublisher = 'GSS';
    APIGroup = 'SalesTeam';
    APIVersion = 'v1.0';
    EntityName = 'SalespeopleTeams';
    EntitySetName = 'SalespeopleTeams';
    SourceTable = "Team Salesperson";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(SalesTeams)
            {
                field(Team_Code; Rec."Team Code")
                {
                }
                field(Team_Name; Rec."Team Name")
                {
                }
                field(Salesperson_Code; Rec."Salesperson Code")
                {
                }
                field(Salesperson_Name; Rec."Salesperson Name")
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
    end;
    trigger OnInit()
    begin
    end;
}
