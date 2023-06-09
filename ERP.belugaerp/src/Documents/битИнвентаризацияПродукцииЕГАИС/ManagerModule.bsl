
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПодчиненныеДокументы(ИнвентаризацияПродукцииЕГАИС) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнутреннееПотреблениеТоваров.Ссылка КАК Документ,
	|	ВнутреннееПотреблениеТоваров.Проведен КАК Проведен,
	|	ВнутреннееПотреблениеТоваров.ПометкаУдаления КАК ПометкаУдаления,
	|	ВнутреннееПотреблениеТоваров.Номер КАК Номер
	|ПОМЕСТИТЬ ВнутреннееПотреблениеТоваров
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|ГДЕ
	|	ВнутреннееПотреблениеТоваров.бг_ИнвентаризацияПродукцииЕГАИС = &ИнвентаризацияПродукцииЕГАИС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрочееОприходованиеТоваров.Ссылка КАК Документ,
	|	ПрочееОприходованиеТоваров.Проведен КАК Проведен,
	|	ПрочееОприходованиеТоваров.ПометкаУдаления КАК ПометкаУдаления,
	|	ПрочееОприходованиеТоваров.Номер КАК Номер
	|ПОМЕСТИТЬ ПрочееОприходованиеТоваров
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров КАК ПрочееОприходованиеТоваров
	|ГДЕ
	|	ПрочееОприходованиеТоваров.бг_ИнвентаризацияПродукцииЕГАИС = &ИнвентаризацияПродукцииЕГАИС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""ПрочееОприходованиеТоваров"" КАК ИмяДокумента,
	|	ПрочееОприходованиеТоваров.Документ КАК Документ,
	|	ПрочееОприходованиеТоваров.Проведен КАК Проведен,
	|	ПрочееОприходованиеТоваров.ПометкаУдаления КАК ПометкаУдаления,
	|	ПрочееОприходованиеТоваров.Номер КАК Номер
	|ИЗ
	|	ПрочееОприходованиеТоваров КАК ПрочееОприходованиеТоваров
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ВнутреннееПотреблениеТоваров"",
	|	ВнутреннееПотреблениеТоваров.Документ,
	|	ВнутреннееПотреблениеТоваров.Проведен,
	|	ВнутреннееПотреблениеТоваров.ПометкаУдаления,
	|	ВнутреннееПотреблениеТоваров.Номер
	|ИЗ
	|	ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	""ПриходныйОрдерНаТовары"",
	|	ПриходныйОрдерНаТовары.Ссылка,
	|	ПриходныйОрдерНаТовары.Проведен,
	|	ПриходныйОрдерНаТовары.ПометкаУдаления,
	|	ПриходныйОрдерНаТовары.Номер
	|ИЗ
	|	ПрочееОприходованиеТоваров КАК ПрочееОприходованиеТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходныйОрдерНаТовары КАК ПриходныйОрдерНаТовары
	|		ПО ПрочееОприходованиеТоваров.Документ = ПриходныйОрдерНаТовары.Распоряжение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	""РасходныйОрдерНаТовары"",
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Ссылка,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Проведен,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.ПометкаУдаления,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Номер
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|		ПО РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение = ВнутреннееПотреблениеТоваров.Документ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""АктСписанияЕГАИС"",
	|	АктСписанияЕГАИС.Ссылка,
	|	АктСписанияЕГАИС.Проведен,
	|	АктСписанияЕГАИС.ПометкаУдаления,
	|	АктСписанияЕГАИС.Номер
	|ИЗ
	|	Документ.АктСписанияЕГАИС КАК АктСписанияЕГАИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|		ПО АктСписанияЕГАИС.ДокументОснование = ВнутреннееПотреблениеТоваров.Документ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""АктПостановкиНаБалансЕГАИС"",
	|	АктПостановкиНаБалансЕГАИС.Ссылка,
	|	АктПостановкиНаБалансЕГАИС.Проведен,
	|	АктПостановкиНаБалансЕГАИС.ПометкаУдаления,
	|	АктПостановкиНаБалансЕГАИС.Номер
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС КАК АктПостановкиНаБалансЕГАИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПрочееОприходованиеТоваров КАК ПрочееОприходованиеТоваров
	|		ПО АктПостановкиНаБалансЕГАИС.ДокументОснование = ПрочееОприходованиеТоваров.Документ";
		
	Запрос.УстановитьПараметр("ИнвентаризацияПродукцииЕГАИС", ИнвентаризацияПродукцииЕГАИС);
	
	РезультатЗапроса = Запрос.Выполнить();
	ПодчиненныеДокументы = РезультатЗапроса.Выгрузить();
	
	Возврат ПодчиненныеДокументы;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Отчеты.бг_ДвижениеМарок.ДобавитьКомандуДвижениеМарокПоДокументу(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли
