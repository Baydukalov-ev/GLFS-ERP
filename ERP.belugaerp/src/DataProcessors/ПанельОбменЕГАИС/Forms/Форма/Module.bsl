#Область ОбработчикиСобытий

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
    бг_ДобавитьГруппыДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_ОткрытьбитЗаявлениеОВыдачеФСМ(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битЗаявлениеОВыдачеФСМ.ФормаСписка",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитЗаявлениеОВыдачеФСМОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битЗаявлениеОВыдачеФСМ.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитЗаявлениеОВыдачеФСМОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битЗаявлениеОВыдачеФСМ.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитНакладнаяНаВыдачуФСМ(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.битНакладнаяНаВыдачуФСМ.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитАктОбУничтоженииФСМ(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битАктОбУничтоженииФСМ.ФормаСписка",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитАктОбУничтоженииФСМОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битАктОбУничтоженииФСМ.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитАктОбУничтоженииФСМОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битАктОбУничтоженииФСМ.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитДобавлениеНовойПродукцииЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.битДобавлениеНовойПродукцииЕГАИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитДобавлениеНовойПродукцииЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битДобавлениеНовойПродукцииЕГАИС.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитДобавлениеНовойПродукцииЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битДобавлениеНовойПродукцииЕГАИС.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитПланируемыйВвозЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов("Документ.битПланируемыйВвозЕГАИС.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитПланируемыйВвозЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битПланируемыйВвозЕГАИС.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитПланируемыйВвозЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битПланируемыйВвозЕГАИС.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОбИмпортеПродукцииЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОбИмпортеПродукцииЕГАИС.ФормаСписка",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОбИмпортеПродукцииЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОбИмпортеПродукцииЕГАИС.ФормаСписка",
		Неопределено, Истина);

КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОбИмпортеПродукцииЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОбИмпортеПродукцииЕГАИС.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОбИмпортеПродукцииЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОбИмпортеПродукцииЕГАИС.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОПроизводствеЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОПроизводствеЕГАИС.ФормаСписка",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОПроизводствеЕГАИСОформите(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОПроизводствеЕГАИС.ФормаСписка",
		Неопределено, Истина);

КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОПроизводствеЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОПроизводствеЕГАИС.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитОтчетОПроизводствеЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битОтчетОПроизводствеЕГАИС.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИС(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИС.ФормаСписка",
		"ВсеТребующиеДействияИлиОжидания");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИСОтработайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИС.ФормаСписка",
		"ВсеТребующиеДействия");
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОткрытьбитУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИСОжидайте(Команда)
	
	ОткрытьФормуСпискаДокументов(
		"Документ.битУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИС.ФормаСписка",
		"ВсеТребующиеОжидания");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
&ИзменениеИКонтроль("ОбновитьСпискиДокументовЕГАИС")
Процедура бг_ОбновитьСпискиДокументовЕГАИС()
	
#Вставка
	УстановитьПривилегированныйРежим(Истина);
#КонецВставки
	
	ТаблицаДокументы = Новый ТаблицаЗначений;
	ТаблицаДокументы.Колонки.Добавить("Метаданные");
	ТаблицаДокументы.Колонки.Добавить("Заголовок");
	ТаблицаДокументы.Колонки.Добавить("Оформите");
	ТаблицаДокументы.Колонки.Добавить("Отработайте");
	ТаблицаДокументы.Колонки.Добавить("Ожидайте");
	ТаблицаДокументы.Колонки.Добавить("ЕстьПравоЧтение");
	ТаблицаДокументы.Колонки.Добавить("ЕстьПравоДобавление");
	ТаблицаДокументы.Колонки.Добавить("ЕстьПравоРедактирование");
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ТТНВходящаяЕГАИС,
		НСтр("ru = 'Товарно-транспортные накладные ЕГАИС (входящие)';
			|en = 'Товарно-транспортные накладные ЕГАИС (входящие)'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ТТНИсходящаяЕГАИС,
		НСтр("ru = 'Товарно-транспортные накладные ЕГАИС (исходящие)';
			|en = 'Товарно-транспортные накладные ЕГАИС (исходящие)'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ТранспортнаяНакладнаяЕГАИС,
		НСтр("ru = 'Транспортные накладные ЕГАИС';
			|en = 'Транспортные накладные ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.АктПостановкиНаБалансЕГАИС,
		НСтр("ru = 'Акты постановки на баланс ЕГАИС';
			|en = 'Акты постановки на баланс ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.АктСписанияЕГАИС,
		НСтр("ru = 'Акты списания ЕГАИС';
			|en = 'Акты списания ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ПередачаВРегистр2ЕГАИС,
		НСтр("ru = 'Передачи в регистр №2 ЕГАИС';
			|en = 'Передачи в регистр №2 ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ВозвратИзРегистра2ЕГАИС,
		НСтр("ru = 'Возвраты из регистра №2 ЕГАИС';
			|en = 'Возвраты из регистра №2 ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ОстаткиЕГАИС,
		НСтр("ru = 'Остатки ЕГАИС';
			|en = 'Остатки ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ОтчетЕГАИС,
		НСтр("ru = 'Отчеты ЕГАИС';
			|en = 'Отчеты ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЗапросАкцизныхМарокЕГАИС,
		НСтр("ru = 'Запросы акцизных марок ЕГАИС';
			|en = 'Запросы акцизных марок ЕГАИС'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
#Вставка		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битЗаявлениеОВыдачеФСМ,
		Метаданные.Документы.битЗаявлениеОВыдачеФСМ.ПредставлениеСписка,
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битНакладнаяНаВыдачуФСМ,
		Метаданные.Документы.битНакладнаяНаВыдачуФСМ.ПредставлениеСписка,
		Ложь,  // Оформите
		Ложь,  // Отработайте
		Ложь); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битАктОбУничтоженииФСМ,
		Метаданные.Документы.битАктОбУничтоженииФСМ.ПредставлениеСписка,
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битДобавлениеНовойПродукцииЕГАИС,
		Метаданные.Документы.битДобавлениеНовойПродукцииЕГАИС.ПредставлениеСписка,
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битПланируемыйВвозЕГАИС,
		Метаданные.Документы.битПланируемыйВвозЕГАИС.ПредставлениеСписка,
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битОтчетОбИмпортеПродукцииЕГАИС,
		Метаданные.Документы.битОтчетОбИмпортеПродукцииЕГАИС.ПредставлениеСписка,
		Истина,  // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битОтчетОПроизводствеЕГАИС,
		Метаданные.Документы.битОтчетОПроизводствеЕГАИС.ПредставлениеСписка,
		Истина,  // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
		
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.битУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИС,
		НСтр("ru = 'Уведомления о начале оборота АП';
			|en = 'Уведомления о начале оборота АП'"),
		Ложь,    // Оформите
		Истина,  // Отработайте
		Истина); // Ожидайте
#КонецВставки
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЧекЕГАИС,
		НСтр("ru = 'Чеки ЕГАИС';
			|en = 'Чеки ЕГАИС'"),
		Истина, Истина, Истина);
	
	ДобавитьДокумент(
		ТаблицаДокументы,
		Метаданные.Документы.ЧекЕГАИСВозврат,
		НСтр("ru = 'Чеки ЕГАИС на возврат';
			|en = 'Чеки ЕГАИС на возврат'"),
		Истина, Истина, Истина);
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ВсеТребующиеОжидания = Новый Массив;
	ВсеТребующиеДействия = Новый Массив;
	
	Для Каждого ТекЭлемент Из ТаблицаДокументы Цикл
		
		Если Не ТекЭлемент.ЕстьПравоЧтение Тогда
			Элементы["Группа" + ТекЭлемент.Метаданные.Имя].Видимость = Ложь;
			Продолжить;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекЭлемент.Метаданные.ПолноеИмя());
		
		Для Каждого Элемент Из МенеджерОбъекта.ВсеТребующиеОжидания() Цикл
			Если ВсеТребующиеОжидания.Найти(Элемент) = Неопределено Тогда
				ВсеТребующиеОжидания.Добавить(Элемент);
			КонецЕсли;
		КонецЦикла;
		Для Каждого Элемент Из МенеджерОбъекта.ВсеТребующиеДействия() Цикл
			Если ВсеТребующиеДействия.Найти(Элемент) = Неопределено Тогда
				ВсеТребующиеДействия.Добавить(Элемент);
			КонецЕсли;
		КонецЦикла;
		
		Если ТекЭлемент.Оформите И ТекЭлемент.ЕстьПравоДобавление Тогда
			ТекстыЗапроса.Добавить(
				МенеджерОбъекта.ТекстЗапросаПанельОбменСЕГАИСОформите(),
				ТекЭлемент.Метаданные.Имя + "Оформите");
		КонецЕсли;
		
		Если ТекЭлемент.Отработайте И ТекЭлемент.ЕстьПравоРедактирование Тогда
			ТекстыЗапроса.Добавить(
				МенеджерОбъекта.ТекстЗапросаПанельОбменСЕГАИСОтработайте(),
				ТекЭлемент.Метаданные.Имя + "Отработайте");
		КонецЕсли;
		
		Если ТекЭлемент.Ожидайте Тогда
			ТекстыЗапроса.Добавить(
				МенеджерОбъекта.ТекстЗапросаПанельОбменСЕГАИСОжидайте(),
				ТекЭлемент.Метаданные.Имя + "Ожидайте");
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекстыЗапроса.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ОрганизацияЕГАИС",            ОрганизацииЕГАИС);
	ПараметрыЗапроса.Вставить("БезОтбораПоОрганизацииЕГАИС", ОрганизацииЕГАИС.Количество() = 0);
	ПараметрыЗапроса.Вставить("Ответственный",        ?(ЗначениеЗаполнено(Ответственный), Ответственный,    Неопределено));
	ПараметрыЗапроса.Вставить("ВсеТребующиеОжидания", ВсеТребующиеОжидания);
	ПараметрыЗапроса.Вставить("ВсеТребующиеДействия", ВсеТребующиеДействия);
	
	Запрос = Новый Запрос;
	Для Каждого ТекПараметр Из ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	РезультатыЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, ТекстыЗапроса);
	
	Для ТекИндекс = 0 По ТаблицаДокументы.Количество() - 1 Цикл
		
		ТекЭлемент = ТаблицаДокументы[ТекИндекс];
		ИмяДокумента = ТекЭлемент.Метаданные.Имя;
		
		Если НЕ ТекЭлемент.ЕстьПравоЧтение Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщееКоличество  = 0;
		ТоваровКПередаче = 0;
		
		ЕстьПередачаВРегистр2ЕГАИС = Ложь;
		
		Если ТекЭлемент.Оформите Тогда
			КнопкаОформите = Элементы["Открыть" + ИмяДокумента + "Оформите"];
			ПустаяОформите = Элементы["Открыть" + ИмяДокумента + "ОформитеДекорация"];
			ТекстОформите  = НСтр("ru = 'оформите';
									|en = 'оформите'");
			
			Если ТекЭлемент.ЕстьПравоДобавление Тогда
				Если ТекЭлемент.Метаданные = Метаданные.Документы.ПередачаВРегистр2ЕГАИС Тогда
					
					ЕстьПередачаВРегистр2ЕГАИС = Истина;
					ТоваровКПередаче = ВывестиПоказатель(
						РезультатыЗапроса[ТекЭлемент.Метаданные.Имя + "Оформите"].Выбрать(), КнопкаОформите, ТекстОформите, Истина);
					
				ИначеЕсли ТекЭлемент.Метаданные = Метаданные.Документы.АктПостановкиНаБалансЕГАИС Тогда
					
					Выборка = РезультатыЗапроса[ТекЭлемент.Метаданные.Имя + "Оформите"].Выбрать();
					КоличествоДокументов = ?(Выборка.Следующий(), Выборка.КоличествоДокументов, 0);
					
					Если Цел(КоличествоДокументов) > 0 Тогда
						ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(Цел(КоличествоДокументов), КнопкаОформите, ТекстОформите);
					ИначеЕсли КоличествоДокументов > 0 Тогда
						ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(1, КнопкаОформите, ТекстОформите, Истина);
					Иначе
						ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(0, КнопкаОформите, ТекстОформите);
					КонецЕсли;
				
				Иначе
					
					ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
					РезультатыЗапроса[ТекЭлемент.Метаданные.Имя + "Оформите"].Выбрать(), КнопкаОформите, ТекстОформите);
					
				КонецЕсли;
				
				ПустаяОформите.Видимость = Ложь;
			Иначе
				КнопкаОформите.Видимость = Ложь;
				ПустаяОформите.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекЭлемент.Отработайте Тогда
			КнопкаОтработайте = Элементы["Открыть" + ИмяДокумента + "Отработайте"];
			ПустаяОтработайте = Элементы["Открыть" + ИмяДокумента + "ОтработайтеДекорация"];
			ТекстОтработайте  = НСтр("ru = 'отработайте';
									|en = 'отработайте'");
			
			Если ТекЭлемент.ЕстьПравоРедактирование Тогда
				ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
					РезультатыЗапроса[ТекЭлемент.Метаданные.Имя + "Отработайте"].Выбрать(), КнопкаОтработайте, ТекстОтработайте);
				
				ПустаяОтработайте.Видимость = Ложь;
			Иначе
				КнопкаОтработайте.Видимость = Ложь;
				ПустаяОтработайте.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекЭлемент.Ожидайте Тогда
			КнопкаОжидайте = Элементы["Открыть" + ИмяДокумента + "Ожидайте"];
			ТекстОжидайте  = НСтр("ru = 'ожидайте';
									|en = 'ожидайте'");
			
			ОбщееКоличество = ОбщееКоличество + ВывестиПоказатель(
				РезультатыЗапроса[ТекЭлемент.Метаданные.Имя + "Ожидайте"].Выбрать(), КнопкаОжидайте, ТекстОжидайте);
		КонецЕсли;
		
		Если ЕстьПередачаВРегистр2ЕГАИС И ОбщееКоличество = 0 И ТоваровКПередаче > 0 Тогда
			ВывестиПоказатель(
				1,
				Элементы["Открыть" + ИмяДокумента],
				ТекЭлемент.Заголовок, Истина);
		Иначе
			ВывестиПоказатель(
				ОбщееКоличество,
				Элементы["Открыть" + ИмяДокумента],
				ТекЭлемент.Заголовок);
		КонецЕсли;
		
	КонецЦикла;
	
	СохранитьНастройкиФормы();
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьГруппыДокументов()

	// Закупки 
	бг_ДобавитьЭлементыПоДокументу("битЗаявлениеОВыдачеФСМ", Элементы.ГруппаЗакупки, Ложь, Истина, Истина);
	бг_ДобавитьЭлементыПоДокументу("битНакладнаяНаВыдачуФСМ", Элементы.ГруппаЗакупки, Ложь, Ложь, Ложь);
	бг_ДобавитьЭлементыПоДокументу("битАктОбУничтоженииФСМ", Элементы.ГруппаЗакупки, Ложь, Истина, Истина);
	бг_ДобавитьЭлементыПоДокументу("битДобавлениеНовойПродукцииЕГАИС", Элементы.ГруппаЗакупки, Ложь, Истина, Истина);
	бг_ДобавитьЭлементыПоДокументу("битПланируемыйВвозЕГАИС", Элементы.ГруппаЗакупки, Ложь, Истина, Истина);
	бг_ДобавитьЭлементыПоДокументу("битОтчетОбИмпортеПродукцииЕГАИС", Элементы.ГруппаЗакупки, Истина, Истина, Истина);
	
	// Производство
	бг_ДобавитьРазделПроизводство();
	бг_ДобавитьЭлементыПоДокументу(
		"битОтчетОПроизводствеЕГАИС",
		Элементы["бг_ГруппаДокументыПроизводства"],
		Истина,
		Истина,
		Истина);
	
	бг_ДобавитьЭлементыПоДокументу(
		"битУведомлениеОНачалеОборотаНаТерриторииРФАПЕГАИС",
		Элементы["бг_ГруппаДокументыПроизводства"],
		Ложь,
		Истина,
		Истина);
		
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьРазделПроизводство()

	КонтекстГруппы = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(
		ЭтаФорма, 
		Элементы.Документы, 
		Элементы.ГруппаПродажи,
		бг_СвойстваВертикальнойГруппы());
		
	ГруппаДокументыПроизводства = бг_ПрограммныйИнтерфейс.НоваяГруппаФормы(
		КонтекстГруппы, 
		"бг_ГруппаДокументыПроизводства", 
		"Производство");

КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыПоДокументу(ИмяДокумента, Родитель, Оформите, Отработайте, Ожидайте)

	КонтекстОсновнойГруппы = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(
		ЭтаФорма, 
		Родитель, 
		, // РасположитьПередЭлементом
		бг_СвойстваГоризонтальнойГруппыБезОтображения());
		
	ОсновнаяГруппа = бг_ПрограммныйИнтерфейс.НоваяГруппаФормы(
		КонтекстОсновнойГруппы, 
		"бг_Группа" + ИмяДокумента, 
		Метаданные.Документы[ИмяДокумента].ПредставлениеСписка);
	ОсновнаяГруппа.Высота = 1;	
	ОсновнаяГруппа.РастягиватьПоГоризонтали = Ложь;
	ОсновнаяГруппа.РастягиватьПоВертикали = Ложь;
		
	КонтекстВложеннойГруппы = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(
		ЭтаФорма, 
		ОсновнаяГруппа,,
		бг_СвойстваГоризонтальнойГруппыБезОтображения());
			
	// Заголовок	
	ГруппаЗаголовок = бг_ПрограммныйИнтерфейс.НоваяГруппаФормы(
		КонтекстВложеннойГруппы, 
		"бг_Группа" + ИмяДокумента + "Заголовок", 
		НСтр("ru = 'Заголовок'"));
	ГруппаЗаголовок.Высота = 1;	
	ГруппаЗаголовок.Ширина = 40;
	ГруппаЗаголовок.РастягиватьПоГоризонтали = Ложь;
	ГруппаЗаголовок.РастягиватьПоВертикали = Ложь;
	
	КонтекстГиперссылки = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, ГруппаЗаголовок);
	Гиперссылка = бг_ПрограммныйИнтерфейс.НоваяКомандаИГиперссылкаФормы(
		КонтекстГиперссылки,
		"Открыть" + ИмяДокумента, 
		"бг_Открыть" + ИмяДокумента,
		Метаданные.Документы[ИмяДокумента].ПредставлениеСписка); 
	Гиперссылка.Высота = 1;	
	Гиперссылка.Шрифт = Новый Шрифт(,, Истина); // Полужирный
	Гиперссылка.РастягиватьПоГоризонтали = Ложь;
	Гиперссылка.РастягиватьПоВертикали = Ложь;
		
	// Оформите	
	ГруппаОформите = бг_ПрограммныйИнтерфейс.НоваяГруппаФормы(
		КонтекстВложеннойГруппы, 
		"бг_Группа" + ИмяДокумента + "Оформите", 
		НСтр("ru = 'Оформите'"));
	ГруппаОформите.Высота = 1;
	ГруппаОформите.Ширина = 12;
	ГруппаОформите.РастягиватьПоГоризонтали = Ложь;
	ГруппаОформите.РастягиватьПоВертикали = Ложь;
		
	КонтекстДекорации = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, ГруппаОформите);
	Декорация = бг_НоваяДекорацияФормы(КонтекстДекорации, "Открыть" + ИмяДокумента + "ОформитеДекорация");
	Декорация.Заголовок = НСтр("ru = 'Декорация'");
	Декорация.Вид = ВидДекорацииФормы.Картинка;
	Декорация.Высота = 1;
	Декорация.РастягиватьПоГоризонтали = Ложь;
	Декорация.РастягиватьПоВертикали = Ложь;
	
	Если Оформите Тогда
		КонтекстГиперссылки = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, ГруппаОформите);
		Гиперссылка = бг_ПрограммныйИнтерфейс.НоваяКомандаИГиперссылкаФормы(
			КонтекстГиперссылки,
			"Открыть" + ИмяДокумента + "Оформите", 
			"бг_Открыть" + ИмяДокумента + "Оформите",
			НСтр("ru = 'оформите'"));
		Гиперссылка.Высота = 1;
		Гиперссылка.РастягиватьПоГоризонтали = Ложь;
		Гиперссылка.РастягиватьПоВертикали = Ложь;
	КонецЕсли;
	
	// Отработайте
	ГруппаОтработайте = бг_ПрограммныйИнтерфейс.НоваяГруппаФормы(
		КонтекстВложеннойГруппы, 
		"бг_Группа" + ИмяДокумента + "Отработайте", 
		НСтр("ru = 'Отработайте'"));
	ГруппаОтработайте.Высота = 1;
	ГруппаОтработайте.Ширина = 12;
	ГруппаОтработайте.РастягиватьПоГоризонтали = Ложь;
	ГруппаОтработайте.РастягиватьПоВертикали = Ложь;
	
	КонтекстДекорации = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, ГруппаОтработайте);
	Декорация = бг_НоваяДекорацияФормы(КонтекстДекорации, "Открыть" + ИмяДокумента + "ОтработайтеДекорация");
	Декорация.Заголовок = НСтр("ru = 'Декорация'");
	Декорация.Вид = ВидДекорацииФормы.Картинка;
	Декорация.Высота = 1;
	Декорация.РастягиватьПоГоризонтали = Ложь;
	Декорация.РастягиватьПоВертикали = Ложь;
	
	Если Отработайте Тогда
		КонтекстГиперссылки = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, ГруппаОтработайте);
		Гиперссылка = бг_ПрограммныйИнтерфейс.НоваяКомандаИГиперссылкаФормы(
			КонтекстГиперссылки,
			"Открыть" + ИмяДокумента + "Отработайте", 
			"бг_Открыть" + ИмяДокумента + "Отработайте",
			НСтр("ru = 'отработайте'"));
		Гиперссылка.Высота = 1;
		Гиперссылка.РастягиватьПоГоризонтали = Ложь;
		Гиперссылка.РастягиватьПоВертикали = Ложь;
	КонецЕсли;
		
	// Ожидайте
	ГруппаОжидайте = бг_ПрограммныйИнтерфейс.НоваяГруппаФормы(КонтекстВложеннойГруппы, 
		"бг_Группа" + ИмяДокумента + "Ожидайте", 
		НСтр("ru = 'Ожидайте'"));
	ГруппаОжидайте.Высота = 1;
	ГруппаОжидайте.Ширина = 12;
	ГруппаОжидайте.РастягиватьПоГоризонтали = Ложь;
	
	Если Ожидайте Тогда
		КонтекстГиперссылки = бг_ПрограммныйИнтерфейс.НовыйКонтекстЭлемента(ЭтаФорма, ГруппаОжидайте);
		Гиперссылка = бг_ПрограммныйИнтерфейс.НоваяКомандаИГиперссылкаФормы(
			КонтекстГиперссылки,
			"Открыть" + ИмяДокумента + "Ожидайте", 
			"бг_Открыть" + ИмяДокумента + "Ожидайте",
			НСтр("ru = 'ожидайте'"));
		Гиперссылка.Высота = 1;
		Гиперссылка.РастягиватьПоГоризонтали = Ложь;
		Гиперссылка.РастягиватьПоВертикали = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция бг_СвойстваГоризонтальнойГруппыБезОтображения()
	
	Свойства = Новый Структура;
	
	Свойства.Вставить("Вид",                 ВидГруппыФормы.ОбычнаяГруппа);
	Свойства.Вставить("Отображение",         ОтображениеОбычнойГруппы.Нет);
	Свойства.Вставить("ОтображатьЗаголовок", Ложь);
	
	Возврат Свойства;
	
КонецФункции

&НаСервере
Функция бг_СвойстваВертикальнойГруппы()
	
	Свойства = Новый Структура;
	Свойства.Вставить("Вид", ВидГруппыФормы.ОбычнаяГруппа);
	Свойства.Вставить("Отображение", ОтображениеОбычнойГруппы.ОбычноеВыделение);
	Свойства.Вставить("ОтображатьЗаголовок", Истина);
	Свойства.Вставить("Группировка", ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
	Свойства.Вставить("Объединенная", Истина);
	
	Возврат Свойства;
	
КонецФункции

&НаСервере
Функция бг_НоваяДекорацияФормы(КонтекстЭлемента, ИмяПоля) Экспорт

	Форма = КонтекстЭлемента.Форма;
	Родитель = КонтекстЭлемента.Родитель;
	Свойства = КонтекстЭлемента.Свойства;
	
	ДекорацияФормы = Форма.Элементы.Добавить(ИмяПоля, Тип("ДекорацияФормы"), Родитель);

	ЗаполнитьЗначенияСвойств(ДекорацияФормы, Свойства);	
	
	Возврат ДекорацияФормы;
	
КонецФункции

#КонецОбласти
