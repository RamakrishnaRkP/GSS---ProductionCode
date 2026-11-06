report 60172 "GSSOrder Invoicing Report2"
{
    // ApplicationArea = All;
    // Caption = 'Order Invoicing Report';
    // UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSSOrderInvoicingReport.rdl';

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = sorting("No.")order(ascending)where(GSSStatus=filter(Released|"Pending Approval"));
            RequestFilterFields = "No.", "GSSSalesperson Code", GSSTeam, "Bill-to Customer No.", "Creation Date";
            PrintOnlyIfDetail = true;

            column(No_; "No.")
            {
            }
            column(Creation_Date; "Creation Date")
            {
            }
            column(Bill_to_Customer_No_; "Bill-to Customer No.")
            {
            }
            column(Bill_to_Name; "Bill-to Name")
            {
            }
            column(Bill_to_Name_2; "Bill-to Name 2")
            {
            }
            column(GSSSalesperson_Code; "GSSSalesperson Code")
            {
            }
            column(GSSTeam; GSSTeam)
            {
            }
            column(GSSStatus; GSSStatus)
            {
            }
            column(Status; Status)
            {
            }
            column(SalesPersonName; SalesPersonRec.Name)
            {
            }
            column(FilterText; FilterText)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(CompLogo; CompInfo.Picture)
            {
            }
            column(HideTotals; HideTotals)
            {
            }
            column(GroupByLOB; GroupByLOB)
            {
            }
            column(PostingDate; SalInvHdr."Posting Date")
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Job No."=field("No.");

                column(GSSGlobal_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(GSSGlobal_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(InternalCost; InternalCost)
                {
                }
                column(GSSTotal_Billable_Price; BillablePrice)
                {
                }
                column(GSSTotal_Budgeted_Cost; BudgetedCost)
                {
                }
                column(GSSGross_Margin; GrossProfit)
                {
                }
                column(GM_Without_IntCost; GrossProfitWoInternalCost)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(InternalCost);
                    Clear(BillablePrice);
                    Clear(BudgetedCost);
                    Clear(GrossProfit);
                    Clear(GrossProfitWoInternalCost);
                    if AccountExists(RevenueAccs, "G/L Entry"."G/L Account No.")then BillablePrice:="G/L Entry".Amount * -1;
                    if AccountExists(InternalCostAccs, "G/L Entry"."G/L Account No.")then InternalCost:="G/L Entry".Amount;
                    if AccountExists(CostOfSalesAccs, "G/L Entry"."G/L Account No.")then BudgetedCost:="G/L Entry".Amount;
                    if(BillablePrice = 0) and (BudgetedCost = 0) and (InternalCost = 0)then CurrReport.Skip();
                end;
                trigger OnPreDataItem()
                begin
                    if((GLStartDate <> 0D) and (GLEndDate <> 0D))then begin
                        "G/L Entry".SetRange("Posting Date", GLStartDate, GLEndDate);
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(SalesPersonRec);
                Clear(InternalCost);
                Clear(BillablePrice);
                Clear(BudgetedCost);
                Clear(GrossProfit);
                Clear(GrossProfitWoInternalCost);
                if SalesPersonRec.Get("GSSSalesperson Code")then;
                SalInvHdr.Reset();
                SalInvHdr.SetRange("GSSJob No.", Job."No.");
                if SalInvHdr.FindFirst()then;
            end;
            trigger OnPreDataItem()
            begin
                if UserSetup.Get(UserId)then;
                if UserSetup."SalesPerson Filter" <> '' then Job.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
                HideTotals:=true;
                GroupByLOB:=true;
            end;
        }
    }
    requestpage
    {
        // SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(HideTotals; HideTotals)
                    {
                        Caption = 'Hide Totals';
                        ApplicationArea = All;
                    }
                    field(GroupByLOB; GroupByLOB)
                    {
                        Caption = 'Group By LOB';
                        ApplicationArea = All;
                    }
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
    trigger OnPreReport()
    begin
        HideTotals:=true;
        GroupByLOB:=true;
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
        FilterText:=Job.GetFilters;
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
    trigger OnInitReport()
    begin
        Clear(GLStartDate);
        Clear(GLEndDate);
        InvAccSchedule:='JOBINVREP';
        HideTotals:=true;
        GroupByLOB:=true;
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
}
