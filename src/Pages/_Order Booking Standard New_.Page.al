page 60174 "Order Booking Standard New"
{
    PageType = API;
    Caption = 'OrderBooking';
    APIPublisher = 'GSS';
    APIGroup = 'Standard';
    APIVersion = 'v1.0';
    EntityName = 'OrderBookingStandard';
    EntitySetName = 'OrderBookingStandard';
    SourceTable = "Job Planning Line";
    SourceTableView = WHERE("Line Type"=filter(Budget|"Both Budget and Billable"));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(PostingDate; JobRec."Creation Date")
                {
                }
                field(OrderYear; Date2DMY(JobRec."Creation Date", 3))
                {
                }
                field(Status; JobRec.GSSStatus)
                {
                }
                field(Order_No; Rec."Job No.")
                {
                }
                field(Customer_Name; JobRec."Bill-to Name")
                {
                }
                field(Team; JobRec.GSSTeam)
                {
                }
                field(ItemNo; Rec."No.")
                {
                }
                field(LineDimension1; Rec."GSSGlobal Dimension 1 Code")
                {
                }
                field(LineDimension2; Rec."GSSGlobal Dimension 2 Code")
                {
                }
                field(JobPostingGroup; JobTaskRec."Job Posting Group")
                {
                }
                field(Revenue; Rec."Total Price")
                {
                }
                field(Cost; Rec."Total Cost")
                {
                }
                field(GP; Rec."Total Price" - Rec."Total Cost")
                {
                }
                field(RebateValue;0)
                {
                }
                field(Currency_Code; Rec."Currency Code")
                {
                }
                field(Currency_Factor; Rec."Currency Factor")
                {
                }
                field(CompanyName; CompanyName())
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        if JobRec.Get(Rec."Job No.")then;
        if SalespersonRec.Get(JobRec."GSSSalesperson Code")then;
        if JobTaskRec.Get(Rec."Job No.", Rec."Job Task No.")then;
    end;
    var JobRec: Record Job;
    SalespersonRec: Record "Salesperson/Purchaser";
    JobTaskRec: Record "Job Task";
}
