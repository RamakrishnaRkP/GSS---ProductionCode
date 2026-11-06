report 60170 "Email Schedule"
{
    Caption = 'Email Schedule';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnInitReport()
    var
        InvoicingRep: Report "GSSOrder Invoicing Report2";
        OrderBookingRep: Report "GSSOrder Booking Report2";
        JobLedEntries: Report "Job Ledger Entries - Excel";
        TempBlob: Record "Tenant Media" temporary;
        TempBlob2: Record "Tenant Media" temporary;
        TempBlob3: Record "Tenant Media" temporary;
        VarOutStream: OutStream;
        VarInStreamInv: InStream;
        AttachmentName: Text[250];
        AttachmentName2: Text[250];
        AttachmentName3: Text[250];
        VarOutStream2: OutStream;
        VarOutStream3: OutStream;
        VarInStreamInv2: InStream;
        VarInStreamInv3: InStream;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        txt: Text;
        emailTo: List of[Text];
        SalRecSetup: Record "Sales & Receivables Setup";
    begin
        SalRecSetup.Get();
        Clear(TempBlob);
        Clear(TempBlob2);
        Clear(TempBlob3);
        Clear(VarInStreamInv);
        Clear(VarOutStream);
        Clear(VarInStreamInv2);
        Clear(VarInStreamInv3);
        Clear(VarOutStream2);
        Clear(VarOutStream3);
        Clear(InvoicingRep);
        Clear(OrderBookingRep);
        Clear(JobLedEntries);
        emailTo.Add(SalRecSetup.GSSInvoicingReportEmail);
        TempBlob.Content.CreateOutStream(VarOutStream);
        //  TempBlob2.Content.CreateOutStream(VarOutStream2);
        //  TempBlob3.Content.CreateOutStream(VarOutStream3);
        txt:='Please find attached booking and invoicing reports';
        EmailMessage.Create(emailTo, 'GSS Reports', txt, true);
        InvoicingRep.UseRequestPage(false);
        InvoicingRep.SetGLDateFilter(CalcDate('<-CM>', Today), CalcDate('<CM>', Today), true, true);
        if(InvoicingRep.SaveAs('', ReportFormat::Excel, VarOutStream))then begin
            AttachmentName:=StrSubstNo('Order Invoicing Report_%1.xlsx', Today);
            TempBlob.Content.CreateInStream(VarInStreamInv);
            EmailMessage.AddAttachment(AttachmentName, 'XLSX', VarInStreamInv);
        end;
        /* OrderBookingRep.UseRequestPage(false);
        OrderBookingRep.SetRequestParam(true, true);
        if (OrderBookingRep.SaveAs('', ReportFormat::Excel, VarOutStream2)) then begin
            AttachmentName2 := StrSubstNo('Order Booking Report_ %1.xlsx', Today);
            TempBlob2.Content.CreateInStream(VarInStreamInv2);
            EmailMessage.AddAttachment(AttachmentName2, 'XLSX', VarInStreamInv2);
        end;

        if (JobLedEntries.SaveAs('', ReportFormat::Excel, VarOutStream3)) then begin
            AttachmentName3 := StrSubstNo('Job Ledger Entries_ %1.xlsx', Today);
            TempBlob3.Content.CreateInStream(VarInStreamInv3);
            EmailMessage.AddAttachment(AttachmentName2, 'XLSX', VarInStreamInv3);
        end; */
        Email.Send(EmailMessage, Enum::"Email Scenario"::Notification);
    end;
    var StartDate: Date;
    EndDate: Date;
}
