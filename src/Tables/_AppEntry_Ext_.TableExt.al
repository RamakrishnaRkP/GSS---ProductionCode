tableextension 60135 "AppEntry_Ext" extends "Approval Entry"
{
    fields
    {
        field(60100; Approval_Comment; Text[500])
        {
            DataClassification = CustomerContent;
        }
        field(60101; Notified; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    trigger OnAfterModify()
    var
        AppEntries: Record "Approval Entry";
        AppCheck: Record "Approval Entry";
    begin
        // if Rec.Status = Rec.Status::Open then
        //TriggerLink(); //Commented - KK
        if Rec.Approval_Comment <> '' then InsertApprovalCommentLine(Rec."Record ID to Approve", Rec."Table ID", Rec.Approval_Comment, Rec."Approver ID");
    end;
    local procedure InsertApprovalCommentLine(RecordIDtoApproval: RecordID; TableID: Integer; Appcomments: Text[500]; Approver: Code[50])
    var
        AppCommentLine: Record "Approval Comment Line";
        AppComment: Record "Approval Comment Line";
        EntNo: Integer;
    begin
        Clear(EntNo);
        AppComment.Reset();
        if AppComment.FindLast()then EntNo:=AppComment."Entry No.";
        AppCommentLine.Init();
        AppCommentLine."Entry No.":=EntNo + 1;
        AppCommentLine."Record ID to Approve":=RecordIDtoApproval;
        AppCommentLine.Comment:=Appcomments;
        AppCommentLine."Table ID":=TableID;
        AppCommentLine."User ID":=Approver;
        AppCommentLine."Date and Time":=CurrentDateTime;
        AppCommentLine.Insert();
    end;
    procedure TriggerLink()
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        ContentHeaders: HttpHeaders;
        RequestHeaders: HttpHeaders;
        Content: HttpContent;
        JsonObject: JsonObject;
        responsetext: Text;
        URL: Text;
    begin
        // Set the API URL
        URL:='http://144.91.88.196/CroweNotificationLive/api/Notification/process-approvals';
        HttpRequestMessage.SetRequestUri(URL);
        HttpRequestMessage.Method:='POST';
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders:=HttpClient.DefaultRequestHeaders();
        //Send Request
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage)then begin
            HttpResponseMessage.Content().ReadAs(responsetext);
            if HttpResponseMessage.IsSuccessStatusCode()then begin
            end
            //  Message('Message Sent Successfully. %1', responsetext)
            else
                Message('Error');
        end
        else
            Message('Failed to send request');
    end;
}
