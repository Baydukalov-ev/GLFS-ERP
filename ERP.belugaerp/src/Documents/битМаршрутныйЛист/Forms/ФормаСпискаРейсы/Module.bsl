#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;
	
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_битМаршрутныйЛист" 
		Или ИмяСобытия = "Запись_бг_ТранспортнаяИнформация" Тогда
		ОбновитьТаблицуЗаказы();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьТаблицуЗаказы", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Ответственный));
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикОтборПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПеревозчикПартнер", Перевозчик, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Перевозчик));
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	
	ЭлементыОтбора = Новый Структура("ВидДокумента", ПредопределенноеЗначение("Перечисление.бг_ВидыМаршрутныхЛистов.Рейс"));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЭлементыОтбора);
	ОткрытьФорму("Документ.битМаршрутныйЛист.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Организация));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьТаблицуЗаказы()
	МаршрутныйЛист = Элементы.Список.ТекущаяСтрока;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Заказы, "МаршрутныйЛист", МаршрутныйЛист, Истина);
	Элементы.Заказы.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ЗаказыЗаказ"
		И ЗначениеЗаполнено(Элементы.Заказы.ТекущиеДанные.Заказ) Тогда
		ПоказатьЗначение( , Элементы.Заказы.ТекущиеДанные.Заказ);
	ИначеЕсли Поле.Имя = "ЗаказыДокументОтгрузки"
		И ЗначениеЗаполнено(Элементы.Заказы.ТекущиеДанные.ДокументОтгрузки) Тогда
		ПоказатьЗначение( , Элементы.Заказы.ТекущиеДанные.ДокументОтгрузки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
