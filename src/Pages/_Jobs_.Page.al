page 60102 "Jobs"
{
    PageType = API;
    Caption = 'Jobs';
    APIPublisher = 'GSS';
    APIGroup = 'Jobs';
    APIVersion = 'v1.0';
    EntityName = 'Jobs';
    EntitySetName = 'Jobs';
    SourceTable = Job;
    SourceTableView = sorting("No.")order(ascending); // where(GSSStatus = filter(Released | "Pending Approval"));
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Jobs)
            {
                field(No_; Rec."No.")
                {
                }
                field(Customer_Name; Rec."Bill-to Name")
                {
                }
                field(Sales_Person; SalesPersonRec.Name)
                {
                }
                field(Team; Rec.GSSTeam)
                {
                }
                field(SalesPerson_Code; Rec."GSSSalesperson Code")
                {
                }
                field(Opportunity_No; Rec."Opportunity ID")
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        if SalesPersonRec.Get(Rec."GSSSalesperson Code")then;
    end;
    var SalesPersonRec: Record "Salesperson/Purchaser";
}
