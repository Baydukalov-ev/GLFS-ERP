
#Область ПрограммныйИнтерфейс

Функция бг_ВыделенныеИсточники(Форма, Команда) Экспорт
	
	Источники = Новый Массив;
	
	ИмяКоманды = Команда.Имя;
	
	Если СтрЗаканчиваетсяНа(ИмяКоманды, "ИсторияДействия") Тогда
		Префикс = "бг_";
		Суффикс = "_ИсторияДействия";
	ИначеЕсли СтрЗаканчиваетсяНа(ИмяКоманды, "СтатусНеДействует") Тогда
		Префикс = "бг_Использование";
		Суффикс = "_УстановитьСтатусНеДействует";
	ИначеЕсли СтрЗаканчиваетсяНа(ИмяКоманды, "СтатусДействует") Тогда
		Префикс = "бг_Использование";
		Суффикс = "_УстановитьСтатусДействует";
	Иначе
		Возврат Источники;
	КонецЕсли;
	
	ИмяИсточника = СкидкиНаценкиКлиентСервер.бг_ИмяДинамическогоСписка(ИмяКоманды, Префикс, Суффикс);
	Если ПустаяСтрока(ИмяИсточника) Тогда
		Возврат Источники;
	КонецЕсли;
	
	Если ИмяИсточника = "ВсеПолучатели" Тогда
		Для каждого ВыделеннаяСтрока Из Форма.Элементы["бг_Использование" + ИмяИсточника].ВыделенныеСтроки Цикл
			Источники.Добавить(Форма.Элементы["бг_Использование" + ИмяИсточника].ДанныеСтроки(ВыделеннаяСтрока).Источник);
		КонецЦикла;
	Иначе
		Источники = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Форма.Элементы["бг_Использование" + ИмяИсточника].ВыделенныеСтроки);
	КонецЕсли;
	Возврат Источники;
	
КонецФункции

Процедура бг_ОткрытьФормуВытеснения(ВладелецФормы, ИмяКоманды, СкидкаНаценка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СкидкаНаценка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяКоманды = "бг_ВытеснитьСкидки" Тогда
		ИмяФормы = "бг_ВытеснениеСкидокНаценок";
	ИначеЕсли ИмяКоманды = "бг_ВытеснитьПериодыДействия" Тогда
		ИмяФормы = "бг_ВытеснениеПериодовДействияСкидокНаценок";
	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неверное имя команды (%1)'; en = 'Wrong command name (%1)'"),
			ИмяКоманды
		);
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.СкидкиНаценки.Форма." + ИмяФормы,    // полное имя формы
		Новый Структура("СкидкаНаценка", СкидкаНаценка), // параметры формы
		ВладелецФормы,                                   // владелец
		СкидкаНаценка,                                   // уникальность
		,                                                // окно
		,                                                // навигационная ссылка
		,                                                // оповещение о закрытии
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца  // режим открытия окна
	);
	
КонецПроцедуры

#КонецОбласти