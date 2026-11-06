pageextension 60190 "O365 Activities Ext" extends "O365 Activities"
{
    layout
    {
        modify("Purchase Orders")
        {
            Visible = false;
        }
        addafter("Purchase Orders")
        {
            field("Purchase Order Updated"; TotalPurchOrders)
            {
                Caption = 'Purchase Orders';
                ApplicationArea = Suite;
                //DrillDownPageID = "Purchase Order List";
                ToolTip = 'Specifies purchases orders that are not posted or only partially posted.';

                trigger OnDrillDown()
                begin
                    OngoingPurchases;
                end;
            }
        }
        addafter("Sales This Month")
        {
            field("Sales This Year"; TotalYearSales)
            {
                ApplicationArea = All;
                DecimalPlaces = 0: 0;
                DrillDownPageID = "Sales Invoice List";
                ToolTip = 'Specifies the sum of sales in the current year excluding taxes.';

                trigger OnDrillDown()
                begin
                    SalesthisYear;
                end;
            }
            field("Bookings This Year"; AmountLCY)
            {
                ApplicationArea = All;
                DrillDownPageID = "Sales Orders";
                DecimalPlaces = 0: 0;
                ToolTip = 'Specifies the sum of Orders Booked in the current year excluding taxes.';

                trigger OnDrillDown()
                begin
                    OrdersthisYear;
                end;
            }
            field("Bookings This Month"; MonthAmountLCY)
            {
                ApplicationArea = All;
                DrillDownPageID = "Sales Orders";
                DecimalPlaces = 0: 0;
                ToolTip = 'Specifies the sum of Orders Booked in the current year excluding taxes.';

                trigger OnDrillDown()
                begin
                    OrdersthisMonth;
                end;
            }
            field("Actual GP SO"; OrderActualGP)
            {
                ApplicationArea = All;
                DecimalPlaces = 0: 0;

                trigger OnDrillDown()
                begin
                    JobListForGP;
                end;
            }
            field("ActualGP Invoice"; BillablePrice - BudgetedCost)
            {
                ApplicationArea = All;
                DecimalPlaces = 0: 0;

                trigger OnDrillDown()
                begin
                    JobListForGP;
                end;
            }
            field("Open Opportunities"; Rec."Open Opportunities")
            {
                ApplicationArea = RelationshipMgmt;
                DrillDownPageID = "Opportunity List";
                ToolTip = 'Specifies open opportunities.';
            }
            field("Opportunities Due in 7 Days"; Rec."Opportunities Due in 7 Days")
            {
                ApplicationArea = RelationshipMgmt;
                DrillDownPageID = "Opportunity Entries";
                Style = Favorable;
                StyleExpr = TRUE;
                ToolTip = 'Specifies opportunities with a due date in seven days or more.';
            }
            field("Overdue Opportunities"; Rec."Overdue Opportunities")
            {
                ApplicationArea = RelationshipMgmt;
                DrillDownPageID = "Opportunity Entries";
                Style = Unfavorable;
                StyleExpr = TRUE;
                ToolTip = 'Specifies opportunities that have exceeded the due date.';
            }
            field("Closed Opportunities"; Rec."Closed Opportunities")
            {
                ApplicationArea = RelationshipMgmt;
                DrillDownPageID = "Opportunity List";
                ToolTip = 'Specifies opportunities that have been closed.';
            }
        }
    }
    trigger OnOpenPage()
    begin
        //  Rec.SetRange(SalesThisYearFilter, CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        // Rec.SetRange(OrdersThisYearFilter, CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if UserSetup.Get(UserId)then;
        Rec.SetFilter("Due Date FilterOPP", '<>%1&%2..%3', 0D, WorkDate, WorkDate + 7);
        Rec.SetFilter("Overdue Date FilterOPP", '<>%1&..%2', 0D, WorkDate - 1);
    end;
    trigger OnAfterGetRecord()
    var
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
        CurrExchRate: Record "Currency Exchange Rate";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLEntryRec: Record "G/L Entry";
        CurrRec: Record Currency;
        JobMonthRec: Record Job;
        PurchRec: Record "Purchase Header";
    begin
        Clear(AmountLCY);
        Clear(TotalYearSales);
        Clear(TotalOverdueSalesInvoice);
        Clear(TotalMonthSales);
        Clear(MonthAmountLCY);
        Clear(OrderActualGP);
        Clear(TotalPurchOrders);
        PurchRec.Reset();
        PurchRec.SetRange("Document Type", PurchRec."Document Type"::Order);
        if UserSetup."SalesPerson Filter" <> '' then PurchRec.SetFilter("Purchaser Code", UserSetup."SalesPerson Filter");
        PurchRec.SetFilter(Status, '%1|%2|%3|%4', PurchRec.Status::Open, PurchRec.Status::"Pending Approval", PurchRec.Status::Released, PurchRec.Status::"Pending Prepayment");
        if PurchRec.FindSet()then TotalPurchOrders:=PurchRec.Count;
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobRec.SetRange("Creation Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if JobRec.FindSet()then repeat /*  if ((JobRec."Invoice Currency Code" <> '') and (JobRec."GSSCustomer PO Amount" <> 0)) then begin
                     CurrRec.Get(JobRec."Invoice Currency Code");
                     AmountLCY += CurrExchRate.ExchangeAmtFCYToLCY(
                            JobRec."Creation Date", JobRec."Invoice Currency Code", JobRec."GSSCustomer PO Amount", CurrRec."Currency Factor");
                 end else begin */
                AmountLCY+=JobRec."GSSCustomer PO Amount";
            // end;
            until JobRec.Next() = 0;
        JobMonthRec.Reset();
        JobMonthRec.SetFilter(GSSStatus, '<>%1', JobMonthRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobMonthRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobMonthRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if JobMonthRec.FindSet()then repeat /* if ((JobMonthRec."Invoice Currency Code" <> '') and (JobMonthRec."GSSCustomer PO Amount" <> 0)) then begin
                    CurrRec.Get(JobMonthRec."Invoice Currency Code");
                    MonthAmountLCY += CurrExchRate.ExchangeAmtFCYToLCY(
                           JobMonthRec."Creation Date", JobMonthRec."Invoice Currency Code", JobMonthRec."GSSCustomer PO Amount", CurrRec."Currency Factor");
                end else begin */
                MonthAmountLCY+=JobMonthRec."GSSCustomer PO Amount";
            //end;
            until JobMonthRec.Next() = 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        if UserSetup."SalesPerson Filter" <> '' then CustLedgerEntry.Setfilter("Salesperson Code", UserSetup."SalesPerson Filter");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if CustLedgerEntry.FindSet()then repeat TotalYearSales+=CustLedgerEntry."Sales (LCY)";
            until CustLedgerEntry.Next() = 0;
        Clear(BillablePrice);
        Clear(InternalCost);
        Clear(BudgetedCost);
        CalculateAccount();
        GlobalJobRec.Reset();
        GlobalJobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        GlobalJobRec.SetFilter(GSSStatus, '%1|%2', GlobalJobRec.GSSStatus::"Pending Approval", GlobalJobRec.GSSStatus::Released);
        if GlobalJobRec.FindSet()then repeat GLRec.SetRange("Job No.", GlobalJobRec."No.");
                if GLRec.FindSet()then repeat if AccountExists(RevenueAccs, GLRec."G/L Account No.")then BillablePrice+=(GLRec.Amount * -1);
                        if AccountExists(InternalCostAccs, GLRec."G/L Account No.")then InternalCost+=GLRec.Amount;
                        if AccountExists(CostOfSalesAccs, GLRec."G/L Account No.")then BudgetedCost+=GLRec.Amount;
                    until GLRec.Next() = 0;
            until GlobalJobRec.Next() = 0;
        OrderJobRec.Reset();
        OrderJobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        OrderJobRec.SetFilter(GSSStatus, '%1|%2', OrderJobRec.GSSStatus::"Pending Approval", OrderJobRec.GSSStatus::Released);
        if UserSetup."SalesPerson Filter" <> '' then OrderJobRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        if OrderJobRec.FindSet()then repeat JobPlRec.SetRange("Job No.", OrderJobRec."No.");
                JobPlRec.SetFilter("Line Type", '%1|%2', JobPlRec."Line Type"::Budget, JobPlRec."Line Type"::"Both Budget and Billable");
                if JobPlRec.FindSet()then repeat Clear(OrderInternalCost);
                        if JobPlRec.Type = JobPlRec.Type::Item then begin
                            case JobPlRec."No." of 'AMC-APL': OrderInternalCost:=JobPlRec."Total Cost";
                            'AMC-DTS': OrderInternalCost:=JobPlRec."Total Cost";
                            'AMC-ESS': OrderInternalCost:=JobPlRec."Total Cost";
                            'AMC-NSS': OrderInternalCost:=JobPlRec."Total Cost";
                            'PS-APL': OrderInternalCost:=JobPlRec."Total Cost";
                            'PS-DTS': OrderInternalCost:=JobPlRec."Total Cost";
                            'PS-ESS': OrderInternalCost:=JobPlRec."Total Cost";
                            'PS-NSS': OrderInternalCost:=JobPlRec."Total Cost";
                            end;
                        end;
                        OrderActualGP+=(JobPlRec."Total Price" - (JobPlRec."Total Cost"))until JobPlRec.Next() = 0;
            until OrderJobRec.Next() = 0;
    end;
    trigger OnPageBackgroundTaskError(TaskId: Integer; ErrorCode: Text; ErrorText: Text; ErrorCallStack: Text; var IsHandled: Boolean)
    var
    begin
        Rec.Reset();
        if not Rec.Get()then begin
            Rec.Init();
            Rec.Insert();
            Commit();
        end;
    end;
    local procedure SalesthisYear()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LogInManagement: Codeunit LogInManagement;
    begin
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Posting Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgerEntry);
    end;
    /*  local procedure SalesthisMonth()
     var
         GLEntry: Record "G/L Entry";
         LogInManagement: Codeunit LogInManagement;
     begin
         //if UserSetup."Salespers./Purch. Code" <> '' then
         // GLEntry.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
         GLEntry.SetFilter("Document Type", '%1|%2',
           GLEntry."Document Type"::Invoice, GLEntry."Document Type"::"Credit Memo");
         GLEntry.SetFilter("G/L Account No.", '=%1', '41101');
         GLEntry.SetRange("Posting Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
         PAGE.Run(PAGE::"General Ledger Entries", GLEntry);
     end; */
    /* local procedure OverdueSalesInv()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LogInManagement: Codeunit LogInManagement;
    begin
        if UserSetup."Salespers./Purch. Code" <> '' then
            CustLedgerEntry.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
        CustLedgerEntry.SetFilter("Document Type", '%1', CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetFilter("Due Date", '<%1', LogInManagement.GetDefaultWorkDate());
        CustLedgerEntry.SetFilter("Remaining Amt. (LCY)", '<>%1', 0);
        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgerEntry);
    end; */
    /* local procedure OverduePurchaseInv()
    var
        CustLedgerEntry: Record "Vendor Ledger Entry";
        LogInManagement: Codeunit LogInManagement;
    begin
        //if UserSetup."Salespers./Purch. Code" <> '' then
          //  CustLedgerEntry.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
        CustLedgerEntry.SetFilter("Document Type", '%1', CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetFilter("Due Date", '<%1', LogInManagement.GetDefaultWorkDate());
        CustLedgerEntry.SetFilter("Remaining Amt. (LCY)", '<>%1', 0);
        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgerEntry);
    end; */
    local procedure OrdersthisMonth()
    var
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
    begin
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        if UserSetup."SalesPerson Filter" <> '' then JobRec.SetFilter("GSSSalesperson Code", UserSetup."SalesPerson Filter");
        JobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Job List", JobRec);
    end;
    local procedure OngoingPurchases()
    var
        PurchRec: Record "Purchase Header";
        LogInManagement: Codeunit LogInManagement;
    begin
        PurchRec.Reset();
        PurchRec.SetRange("Document Type", PurchRec."Document Type"::Order);
        if UserSetup."SalesPerson Filter" <> '' then PurchRec.SetFilter("Purchaser Code", UserSetup."SalesPerson Filter");
        PurchRec.SetFilter(Status, '%1|%2|%3|%4', PurchRec.Status::Open, PurchRec.Status::"Pending Approval", PurchRec.Status::Released, PurchRec.Status::"Pending Prepayment");
        PAGE.Run(PAGE::"Purchase Order List", PurchRec);
    end;
    local procedure JobListForGP()
    var
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
    begin
        JobRec.Reset();
        JobRec.SetFilter(GSSStatus, '<>%1', JobRec.GSSStatus::Open);
        JobRec.SetRange("Creation Date", CalcDate('<-CM>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Job List", JobRec);
    end;
    local procedure OrdersthisYear()
    var
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
    begin
        JobRec.Reset();
        JobRec.SetFilter(Status, '<>%1', JobRec.Status::Open);
        JobRec.SetRange("Creation Date", CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        PAGE.Run(PAGE::"Job List", JobRec);
    end;
    local procedure CalculateAccount()
    begin
        InvAccSchedule:='JOBINVREP';
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
    var AmountLCY: Decimal;
    TotalPurchOrders: Integer;
    MonthAmountLCY: Decimal;
    LogInManagement: Codeunit LogInManagement;
    TotalYearSales: Decimal;
    TotalMonthSales: Decimal;
    TotalOverdueSalesInvoice: Decimal;
    TotalOverduePurchaceInvoice: Decimal;
    UserSetup: Record "User Setup";
    I: Integer;
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
    GlobalJobRec: Record Job;
    OrderJobRec: Record Job;
    JobPlRec: Record "Job Planning Line";
    GLRec: Record "G/L Entry";
    BillablePrice: Decimal;
    BudgetedCost: Decimal;
    InternalCost: Decimal;
    OrderInternalCost: Decimal;
    OrderActualGP: Decimal;
}
