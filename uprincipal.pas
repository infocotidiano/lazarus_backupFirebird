unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, process;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edtGBAK: TEdit;
    edtUSER: TEdit;
    edtSENHA: TEdit;
    edtFDB: TEdit;
    edtFBK: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure brnProc_BAKClick(Sender: TObject);
    procedure btnProcura_FdbClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    procedure backupfb();
    procedure restaurafb();
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.brnProc_BAKClick(Sender: TObject);
begin
end;

procedure TfrmPrincipal.btnProcura_FdbClick(Sender: TObject);
begin
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  backupfb();
end;

procedure TfrmPrincipal.Button2Click(Sender: TObject);
begin
  restaurafb();
end;

procedure TfrmPrincipal.backupfb;
   const READ_BYTES = 2048;
   var
     aProcess : TProcess;
     MemStream : TMemoryStream;
     NumBytes , ByteRead: LongInt;
     Lines : TStringList;
begin
     MemStream := TMemoryStream.Create;
     Lines     := TStringList.Create;
     ByteRead  := 0;
     aProcess  := TProcess.Create(nil);
     aProcess.Executable := edtGBAK.Text;
     aProcess.Parameters.Add('-b');
     aProcess.Parameters.Add('-v');
     aProcess.Parameters.Add('-user');
     aProcess.Parameters.Add(edtUSER.Text);
     aProcess.Parameters.Add('-password');
     aProcess.Parameters.Add(edtSENHA.Text);
     aProcess.Parameters.Add(edtFDB.Text);
     aProcess.Parameters.Add(edtFBK.Text);
     aProcess.ShowWindow:=swoHIDE;
     aProcess.Options:=aProcess.Options + [poUsePipes,poStderrToOutPut];
     Memo1.Lines.Clear;

     Memo1.lines.add('Backup iniciado...');

     aProcess.Execute;
     while aProcess.Running do
        begin
          MemStream.SetSize(ByteRead + READ_BYTES);
          NumBytes:=aProcess.Output.Read((MemStream.Memory+ByteRead)^,READ_BYTES);
          if NumBytes > 0 then
             Inc(ByteRead, NumBytes)
          else
             break
        end;
     MemStream.SetSize(ByteRead);
     lines.LoadFromStream(MemStream);
     memo1.Lines.AddStrings(Lines);
     Memo1.Lines.add('Final de Backup');
     aProcess.Free;
     Lines.free;
     MemStream.free;
end;

procedure TfrmPrincipal.restaurafb;
const READ_BYTES = 2048;
var
  aProcess : TProcess;
  MemStream : TMemoryStream;
  NumBytes , ByteRead: LongInt;
  Lines : TStringList;
begin
  MemStream := TMemoryStream.Create;
  Lines     := TStringList.Create;
  ByteRead  := 0;
  aProcess  := TProcess.Create(nil);
  aProcess.Executable := edtGBAK.Text;
  aProcess.Parameters.Add('-r');
  aProcess.Parameters.Add('-v');
  aProcess.Parameters.Add('-user');
  aProcess.Parameters.Add(edtUSER.Text);
  aProcess.Parameters.Add('-password');
  aProcess.Parameters.Add(edtSENHA.Text);
  aProcess.Parameters.Add(edtFBK.Text);
  aProcess.Parameters.Add(edtFDB.Text);
  aProcess.ShowWindow:=swoHIDE;
  aProcess.Options:=aProcess.Options + [poUsePipes,poStderrToOutPut];
  Memo1.Lines.Clear;

  Memo1.lines.add('Backup iniciado...');

  aProcess.Execute;
  while aProcess.Running do
     begin
       MemStream.SetSize(ByteRead + READ_BYTES);
       NumBytes:=aProcess.Output.Read((MemStream.Memory+ByteRead)^,READ_BYTES);
       if NumBytes > 0 then
          Inc(ByteRead, NumBytes)
       else
          break
     end;
  MemStream.SetSize(ByteRead);
  lines.LoadFromStream(MemStream);
  memo1.Lines.AddStrings(Lines);
  Memo1.Lines.add('Final de Backup');
  aProcess.Free;
  Lines.free;
  MemStream.free;
end;

end.

