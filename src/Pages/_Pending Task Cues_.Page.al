page 60191 "Pending Task Cues"
{
    PageType = CardPart;
    Caption = 'Pending Task';

    layout
    {
        area(content)
        {
            cuegroup(OutboxCueContainer)
            {
                Caption = 'Pending Task';

                field(UserPendingOppTask; UserPendingOppTask)
                {
                    ApplicationArea = All;
                    Caption = 'Pending Oppurtunity Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you or to a group that you are a member of.';
                    DrillDownPageId = "Task List";

                    trigger OnDrillDown()
                    var
                        TaskList: Page "Task List";
                    begin
                        EmployeeRec.Reset();
                        EmployeeRec.SetRange("ATOS User ID", UserId);
                        if EmployeeRec.FindFirst()then begin
                            ToDoRec.Reset();
                            ToDoRec.FilterGroup(100);
                            ToDoRec.SetRange("Pre-Sales Person", EmployeeRec."No.");
                            ToDoRec.SetRange(Closed, false);
                            ToDoRec.FilterGroup(0);
                            TaskList.SetTableView(ToDoRec);
                            TaskList.Run();
                        end;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        //  Rec.SetRange(SalesThisYearFilter, CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        // Rec.SetRange(OrdersThisYearFilter, CalcDate('<-CY>', LogInManagement.GetDefaultWorkDate()), LogInManagement.GetDefaultWorkDate());
        if UserSetup.Get(UserId)then;
    end;
    trigger OnAfterGetCurrRecord()
    var
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobRec: Record Job;
        LogInManagement: Codeunit LogInManagement;
        CurrExchRate: Record "Currency Exchange Rate";
        // [SecurityFiltering(SecurityFilter::Validated)]
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLEntryRec: Record "G/L Entry";
        CurrRec: Record Currency;
        // [SecurityFiltering(SecurityFilter::Filtered)]
        JobMonthRec: Record Job;
    begin
        UserPendingOppTask:=CalcTaskCount();
    end;
    local procedure CalcTaskCount(): Integer begin
        EmployeeRec.Reset();
        EmployeeRec.SetRange("ATOS User ID", UserId);
        if EmployeeRec.FindFirst()then begin
            ToDoRec.Reset();
            ToDoRec.SetRange("Pre-Sales Person", EmployeeRec."No.");
            ToDoRec.SetRange(Closed, false);
            ToDoRec.FindSet();
            exit(ToDoRec.Count);
        end;
    end;
    var AmountLCY: Decimal;
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
    //  [SecurityFiltering(SecurityFilter::Filtered)]
    GlobalJobRec: Record Job;
    GLRec: Record "G/L Entry";
    BillablePrice: Decimal;
    BudgetedCost: Decimal;
    InternalCost: Decimal;
    EmployeeRec: Record Employee;
    ToDoRec: Record "To-do";
    UserPendingOppTask: Integer;
}
