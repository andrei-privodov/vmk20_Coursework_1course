unit Lists;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  TObj = record
    Name, Surname, Patronymic : string[20]; //Индикатор клиента
    Time : TTime; //Время
    Doctor : string[50]; //Специальность Врача
    PolicyNumber : string[16]; //Номер страхового полиса
  end;
  TNode = ^List;        //Тип указателя на узел; List-можно представить как цепь
  List = record
    obj: TObj;          //Cодержание Узла
    next: TNode;
    prev: TNode;
  end;
  TBase = file of TObj; //Файл база данных

procedure AddNodeInBeginningOfTheList(var first:TNode; current:TNode); //добавить узел в начало списка
procedure AddNodeAfter(var old:TNode;current:TNode); //Вставить узел после old
procedure BuildLists(var first,current: TNode); //Создание списка с первым узлом
procedure WriteListInBase(var first:TNode; var base:TBase); //Запись списка в базу данных
procedure RemoveFirstNode(var first,current:TNode); //Удалить первый узел
procedure RemoveNode(var old,current:TNode); //Удалить не первый узел
procedure RemoveList(var first:TNode); //Отчистить память от списка
procedure MaxStringElementDoctor(var first,max:TNode);      //Найти максимальный элемент списка.
procedure MaxStringElementTime(var first,max:TNode);
procedure MinStringElementTime(var first,min:TNode);
procedure SortByDoctors(var first:TNode); //Сортировка Списка
procedure SortByTime(var first:TNode); //Сортировка Списка
procedure SortByTimeRev(var first:TNode); //Сортировка Списка


implementation

procedure AddNodeInBeginningOfTheList(var first: TNode; current: TNode);
begin
  current^.next:=first;
  if first<>nil then first^.prev:=current;
  first:=current;
end;

procedure AddNodeAfter(var old: TNode; current: TNode);
begin
  current^.next:=old^.next;
  old^.next:=current;
  if current^.next<>nil then current^.next^.prev:=current;
  current^.prev:=old;
end;

procedure BuildLists(var first,current: TNode);
var d: TNode;
begin
  if(first=nil) then begin
    AddNodeInBeginningOfTheList(first,current);
    d:=first;
  end else begin
    AddNodeAfter(first,current);
    d:=first;
  end;
end;

procedure WriteListInBase(var first: TNode; var base: TBase);
var p:TNode;fOBJ:TObj;
begin
  p:=first;
  while not(p=nil) do
    begin
      fOBJ:=p^.obj;
      Write(base,fOBJ);
      p:=p^.next;
    end;
end;

procedure RemoveFirstNode(var first, current: TNode);
begin
  current:=first;
  first:=first^.next; //второй узел становиться первым
  current^.next:=nil; //удаляет бессвязный узел из списка
  if first<>nil then first^.prev:=nil;
end;

procedure RemoveNode(var old, current: TNode);
begin
  if (old^.next = nil) then current:=nil
  else
    if (old^.next^.next = nil) then
      begin
        current:=old^.next;
        current^.prev:=nil;
        old^.next:=nil;
      end
    else
      begin
        current := old^.next;
        old^.next := current^.next;
        old^.next^.prev:= old;
        current^.next := nil;
        current^.prev:= nil;
      end;
end;

procedure RemoveList(var first: TNode);
var current: TNode;
begin
  while (first<>nil) do
    begin
    RemoveFirstNode(first,current);
    Dispose(current);
    end;
end;

procedure MaxStringElementDoctor(var first,max:TNode);
var a, Pmax : TNode; maxEl : string;
begin
  a:= first; Pmax:= first;
  maxEl:= a^.obj.Doctor;
  while (a <> nil) do
  begin
    a := a^.next;
    if (a = nil) then break
    else
      if (a^.obj.Doctor > maxEl) then
      begin
        maxEl:= a^.obj.Doctor;
        Pmax:= a;
      end;
  end;
  max:= Pmax;
end;

procedure MaxStringElementTime(var first,max:TNode);
var a, Pmax : TNode; maxEl : TDateTime;
begin
  a:= first; Pmax:= first;
  maxEl:= a^.obj.Time;
  while (a <> nil) do
  begin
    a := a^.next;
    if (a = nil) then break
    else
      if (a^.obj.Time > maxEl) then
      begin
        maxEl:= a^.obj.Time;
        Pmax:= a;
      end;
  end;
  max:= Pmax;
end;

procedure MinStringElementTime(var first,min:TNode);
var a, Pmin : TNode; minEl : TDateTime;
begin
  a:= first; Pmin:= first;
  minEl:= a^.obj.Time;
  while (a <> nil) do
  begin
    a := a^.next;
    if (a = nil) then break
    else
      if (a^.obj.Time < minEl) then
      begin
        minEl:= a^.obj.Time;
        Pmin:= a;
      end;
  end;
  min:= Pmin;
end;

procedure SortByDoctors(var first:TNode);
Var
  f1: TNode;
  a, a1: TNode;
  old: TNode;
begin
  f1:= nil;
  while (first <> nil) do
  begin
    MaxStringElementDoctor(first,a1);
    if (a1=first) then RemoveFirstNode(first,a)
    else begin
      old:= a1^.prev;
      RemoveNode(old, a);
    end;
    AddNodeInBeginningOfTheList(f1,a);
  end;
  first:=f1;
end;

procedure SortByTime(var first:TNode);
Var
  f1: TNode;
  a, a1: TNode;
  old: TNode;
begin
  f1:= nil;
  while (first <> nil) do
  begin
    MaxStringElementTime(first,a1);
    if (a1=first) then RemoveFirstNode(first,a)
    else begin
      old:= a1^.prev;
      RemoveNode(old, a);
    end;
    AddNodeInBeginningOfTheList(f1,a);
  end;
  first:=f1;
end;

procedure SortByTimeRev(var first:TNode);
Var
  f1: TNode;
  a, a1: TNode;
  old: TNode;
begin
  f1:= nil;
  while (first <> nil) do
  begin
    MinStringElementTime(first,a1);
    if (a1=first) then RemoveFirstNode(first,a)
    else begin
      old:= a1^.prev;
      RemoveNode(old, a);
    end;
    AddNodeInBeginningOfTheList(f1,a);
  end;
  first:=f1;
end;

end.

