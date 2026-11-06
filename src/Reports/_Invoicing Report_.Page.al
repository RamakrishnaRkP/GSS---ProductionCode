page 60172 "Invoicing Report"
{
    PageType = API;
    Caption = 'InvoicingReport';
    APIPublisher = 'GSS';
    APIGroup = 'InvoicingReport';
    APIVersion = 'v1.0';
    EntityName = 'InvoicingReport';
    EntitySetName = 'InvoicingReport';
    SourceTable = Job;
    SourceTableView = sorting("No.")order(ascending)where(GSSStatus=filter(Released|"Pending Approval"));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No_; Rec."No.")
                {
                }
                field(Creation_Date; Rec."Creation Date")
                {
                }
                field(Bill_to_Customer_No_; Rec."Bill-to Customer No.")
                {
                }
                field(Bill_to_Name; Rec."Bill-to Name")
                {
                }
                field(Bill_to_Name_2; Rec."Bill-to Name 2")
                {
                }
                field(GSSSalesperson_Code; Rec."GSSSalesperson Code")
                {
                }
                field(GSSTeam; Rec.GSSTeam)
                {
                }
                field(GSSStatus; Rec.GSSStatus)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(SalesPersonName; SalesPersonRec.Name)
                {
                }
                field(PostingDate; SalInvHdr."Posting Date")
                {
                }
                field(InternalCost; InternalCost)
                {
                }
                field(GSSTotal_Billable_Price; BillablePrice)
                {
                }
                field(GSSTotal_Budgeted_Cost; BudgetedCost)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if SalesPersonRec.Get(Rec."GSSSalesperson Code")then;
        SalInvHdr.Reset();
        SalInvHdr.SetRange("GSSJob No.", Rec."No.");
        if SalInvHdr.FindFirst()then;
        GLEntry.Reset();
        if((GLStartDate <> 0D) and (GLEndDate <> 0D))then begin
            GLEntry.SetRange("Posting Date", GLStartDate, GLEndDate);
        end;
        GLEntry.SetRange("Job No.", Rec."No.");
        if GLEntry.FindSet()then repeat Clear(InternalCost);
                Clear(BillablePrice);
                Clear(BudgetedCost);
                Clear(GrossProfit);
                Clear(GrossProfitWoInternalCost);
                if AccountExists(RevenueAccs, GLEntry."G/L Account No.")then BillablePrice+=GLEntry.Amount * -1;
                if AccountExists(InternalCostAccs, GLEntry."G/L Account No.")then InternalCost+=GLEntry.Amount;
                if AccountExists(CostOfSalesAccs, GLEntry."G/L Account No.")then BudgetedCost+=GLEntry.Amount;
            until GLEntry.Next() = 0;
    end;
    trigger OnInit()
    begin
        InvAccSchedule:='JOBINVREP';
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
        FilterText:=Rec.GetFilters;
        if InvAccSchedule = '' then Error('Select Account schedule for Job Invoicing Report.');
        if AccSchedule.Get(InvAccSchedule)then begin
            AccScheduleLines.SetCurrentKey("Schedule Name", "Line No.");
            AccScheduleLines.SetRange("Schedule Name", AccSchedule.Name);
            AccScheduleLines.SetRange(Description, 'Revenue');
            if AccScheduleLines.FindFirst()then RevenueAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Revenue Total');
            if AccScheduleLines.FindFirst()then RevenueAccEnd:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Cost of Sales');
            if AccScheduleLines.FindFirst()then CostOfSalesAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Cost of Sales Total');
            if AccScheduleLines.FindFirst()then CostOfSalesAccEnd:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Internal Cost');
            if AccScheduleLines.FindFirst()then InternalCostAccStart:=AccScheduleLines."Row No.";
            AccScheduleLines.SetRange(Description, 'Internal Cost Total');
            if AccScheduleLines.FindFirst()then InternalCostAccEnd:=AccScheduleLines."Row No.";
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", RevenueAccStart, RevenueAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat RevenueAccs[I]:=AccScheduleLines.Totaling;
                    I+=1;
                until AccScheduleLines.Next() = 0;
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", CostOfSalesAccStart, CostOfSalesAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat CostOfSalesAccs[I]:=AccScheduleLines.Totaling;
                    I+=1;
                until AccScheduleLines.Next() = 0;
            I:=1;
            AccScheduleLines.SetRange(Description);
            AccScheduleLines.SetRange("Row No.", InternalCostAccStart, InternalCostAccEnd);
            AccScheduleLines.SetFilter(Totaling, '<>%1', '');
            if AccScheduleLines.FindFirst()then repeat InternalCostAccs[I]:=AccScheduleLines.Totaling;
                    I+=1;
                until AccScheduleLines.Next() = 0;
        end;
    end;
    local procedure AccountExists(Arr: Array[50]of code[20]; AccNo: Code[20]): Boolean var
        Exists: Boolean;
    begin
        Exists:=false;
        if ArrayLen(Arr) = 0 then exit(Exists);
        for I:=1 to ArrayLen(Arr)do begin
            if Arr[I] = AccNo then begin
                Exists:=true;
                break;
            end;
        end;
        Exit(Exists);
    end;
    procedure SetGLDateFilter(StartDate: Date; EndDate: Date; HideTot: Boolean; LOBGroup: Boolean)
    var
    begin
        GLStartDate:=StartDate;
        GLEndDate:=EndDate;
        HideTotals:=HideTot;
        LOBGroup:=GroupByLOB;
    end;
    var I: Integer;
    InvAccSchedule: Code[20];
    AccSchedule: Record "Acc. Schedule Name";
    AccScheduleLines: Record "Acc. Schedule Line";
    RevenueAccs: array[50]of Code[20];
    CostOfSalesAccs: array[50]of Code[20];
    InternalCostAccs: array[50]of Code[20];
    RevenueAccStart: Text;
    RevenueAccEnd: Text;
    CostOfSalesAccStart: Text;
    CostOfSalesAccEnd: Text;
    InternalCostAccStart: Text;
    InternalCostAccEnd: Text;
    PlannedDeliveryMonth: Text;
    SalesPersonRec: Record "Salesperson/Purchaser";
    FilterText: Text;
    CompInfo: Record "Company Information";
    HideTotals: Boolean;
    HideHeader: Boolean;
    GroupByLOB: Boolean;
    BillablePrice: Decimal;
    BudgetedCost: Decimal;
    InternalCost: Decimal;
    GrossProfit: Decimal;
    GrossProfitWoInternalCost: Decimal;
    SalInvHdr: Record "Sales Invoice Header";
    UserSetup: Record "User Setup";
    GLStartDate: Date;
    GLEndDate: Date;
    GLEntry: Record "G/L Entry";
}
