#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьКомпоновщикНастроекДляОтборов();
	ВосстановитьНастройки();
	
	УстановитьУсловноеОформление();
	
	ИспользоватьОтборТоварныхКатегорийПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Если СохранитьНастройки Тогда
			Отказ = Истина;
			ТекстПредупреждения = 
				НСтр("ru = 'Отбор товарных категорий был изменен. Все изменения будут потеряны.'");
		КонецЕсли;
		Если Модифицированность Тогда
			Отказ = Истина;
			ТекстПредупреждения = 
				НСтр("ru = 'Данные подтвержденных количеств были изменены. Все изменения будут потеряны.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();
	
	Если Модифицированность И Не ВыполняетсяЗакрытие Тогда
		
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены, сохранить изменения?';
							|en = 'Data has changed, save the changes?'");
		ОповещениеОЗакрытии = Новый ОписаниеОповещения(
			"ВопросОСохраненииИзмененийПередЗакрытиемПослеОтвета",
			ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОСохраненииИзмененийПередЗакрытиемПослеОтвета(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		ЗаписатьДанныеНаСервере();
		ВыполняетсяЗакрытие = Истина;
		Закрыть(Неопределено);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкмФормы

&НаКлиенте
Процедура ИспользоватьОтборТоварныхКатегорийПриИзменении(Элемент)
	
	ИспользоватьОтборТоварныхКатегорийПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Период.ДатаОкончания = Период.ДатаНачала;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Период.ДатаНачала = Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатДляВыгрузкиВExcelОбработкаРасшифровки(Элемент, 
														Расшифровка,
														СтандартнаяОбработка,
														ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодтверждаемыеТовары

&НаКлиенте
Процедура ПодтверждаемыеТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПодтверждаемыеТовары.ТекущиеДанные;
	
	Если Поле.Имя = "ПодтверждаемыеТоварыЗаявкаКлиента" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущиеДанные.ЗаявкаКлиента) Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.ЗаявкаКлиента);
			ОткрытьФорму("Документ.битЗаявкаКлиента.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
		КонецЕсли; 
	ИначеЕсли Поле.Имя = "ПодтверждаемыеТоварыТоварнаяКатегория" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущиеДанные.ТоварнаяКатегория) Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.ТоварнаяКатегория);
			ОткрытьФорму("Справочник.ТоварныеКатегории.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
		КонецЕсли; 
	ИначеЕсли Поле.Имя = "ПодтверждаемыеТоварыКонтрагент" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(ТекущиеДанные.Контрагент) Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Ключ", ТекущиеДанные.Контрагент);
			ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждаемыеТоварыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПодтверждаемыеТовары.ТекущиеДанные;
	
	ТекущиеДанные.КоличествоИзменено = Истина;
	ИдентификаторСтроки = ТекущиеДанные.ПолучитьИдентификатор();
	ПодтверждаемыеТоварыКоличествоПриИзмененииСервер(ИдентификаторСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПроизвольныеОтборыЭлементы

&НаКлиенте
Процедура ПроизвольныеОтборыЭлементыПриИзменении(Элемент)
	СохранитьНастройки = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПодтверждаемыеТовары(Команда)
	
	Если Модифицированность Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены, сохранить изменения?';
							|en = 'Data has changed, save the changes?'");
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВопросОСохраненииИзмененийПередЗаполнениемПослеОтвета", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗаполнитьПодтверждаемыеТоварыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОСохраненииИзмененийПередЗаполнениемПослеОтвета(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		ЗаписатьДанныеНаСервере();
		ЗаполнитьПодтверждаемыеТоварыНаСервере();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ЗаполнитьПодтверждаемыеТоварыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВExcel(Команда)
	
	ИмяФайла = СтрШаблон(НСтр("ru = '%1_Подтверждение_количество_товаров_в_предзаказах.xlsx'"), Формат(ТекущаяДата(), "ДФ=yyyy_MM_dd_hhmmss"));
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.ПолноеИмяФайла = ИмяФайла;
	ДиалогВыбораФайла.Фильтр = НСтр("ru = 'Файл Excel(*.xlsx)|*.xlsx'"); 
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Сохранение отчета в файл Excel'");
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ВыгрузитьВExcelЗавершение", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла", ДиалогВыбораФайла)));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзExcel(Команда)
	
	ОчиститьСообщения();
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьИзExcelЗавершение", ЭтотОбъект);
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов();
	ПараметрыДиалога.Заголовок = НСтр("ru = 'Загрузка подтвержденных количеств из файла-отчета'");
	ПараметрыДиалога.МножественныйВыбор = Ложь;
	ПараметрыДиалога.Фильтр =  НСтр("ru = 'Файл Excel(*.xlsx)|*.xlsx'");
	
	НачатьПомещениеФайлаНаСервер(ОписаниеОповещения, , , , ПараметрыДиалога, УникальныйИдентификатор);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтчет(Команда)
	
	СформироватьОтчетДляВыгрузкиВExcel();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные(Команда)
	
	ОчиститьСообщения();
	ЗаписатьДанныеНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	#Область ОформлениеСтрокСИнтерактивноИзмененнымКоличеством
	// Установим жирный шрифт для колонки Количество в измененных строках.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждаемыеТоварыКоличество.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодтверждаемыеТовары.КоличествоИзменено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	#КонецОбласти 
	
	#Область ОформлениеИтоговыхСтрок
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждаемыеТовары.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодтверждаемыеТовары.ЭтоСтрокаГруппировки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаИнформацияДляПользователя);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждаемыеТоварыКоличество.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодтверждаемыеТовары.ЭтоСтрокаГруппировки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	#КонецОбласти 
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьОтборТоварныхКатегорийПриИзмененииСервер()
	
	Элементы.ПроизвольныеОтборыЭлементы.Видимость = ИспользоватьОтборТоварныхКатегорий;
	Если ИспользоватьОтборТоварныхКатегорий Тогда
		Элементы.СтраницаОтборТоварныхКатегорий.Картинка = БиблиотекаКартинок.ОтборПоСтатусуСдан;
	Иначе
		Элементы.СтраницаОтборТоварныхКатегорий.Картинка = БиблиотекаКартинок.Отборы;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодтверждаемыеТоварыКоличествоПриИзмененииСервер(ИдентификаторСтроки)
	
	ОбновитьИтоговыеСтрокиПодтверждаемыхТоваров(ИдентификаторСтроки);
	
КонецПроцедуры

#Область ЗаписьДанныхВЗаявкиКлиентов

&НаСервере
Процедура ЗаписатьДанныеНаСервере()
	
	БылиЗаписаныИзменения = Ложь;
	
	Для Каждого СтрокаТоварнаяКатегория Из ПодтверждаемыеТовары.ПолучитьЭлементы() Цикл
		
		Если Не СтрокаТоварнаяКатегория.КоличествоИзменено Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ДетальнаяЗапись Из СтрокаТоварнаяКатегория.ПолучитьЭлементы() Цикл
			
			Если Не ДетальнаяЗапись.КоличествоИзменено Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаписатьПодтвержденноеКоличествоВЗаявкуКлиента(ДетальнаяЗапись);
			БылиЗаписаныИзменения = Истина;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если БылиЗаписаныИзменения Тогда
		ЗаполнитьПодтверждаемыеТоварыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПодтвержденноеКоличествоВЗаявкуКлиента(ДетальнаяЗапись)
	
	ШаблонНачалоОшибки = бг_ОбщегоНазначенияСервер.СтрокаБезСимволовПереноса(
		НСтр("ru = 'Не удалось записать новое подтвержденное количество %1
			| по товару ""%2"" в заявку (предзаказ) контрагента ""%3"".'")); 
	
	ТекстНачалоОшибки = СтрШаблон(
		ШаблонНачалоОшибки,
		ДетальнаяЗапись.Количество,
		ДетальнаяЗапись.ТоварнаяКатегория,
		ДетальнаяЗапись.Контрагент);
	
	ШаблонОшибки = НСтр("ru = '%1 По причине: %2.'");
	
	Если ЕстьОшибкиЗаполненияСтроки(ДетальнаяЗапись, ШаблонОшибки, ТекстНачалоОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаявкаКлиентаСсылка = ДетальнаяЗапись.ЗаявкаКлиента;
	ЗаявкаКлиентаОбъект = ЗаявкаКлиентаСсылка.ПолучитьОбъект();
	
	ОтборСтрок = Новый Структура("ТоварнаяКатегория,КодПозицииЗаказа");
	ЗаполнитьЗначенияСвойств(ОтборСтрок, ДетальнаяЗапись);
	НайденныеСтрокиТоваровЗаявки = ЗаявкаКлиентаОбъект.Товары.НайтиСтроки(ОтборСтрок);
	
	Если НайденныеСтрокиТоваровЗаявки.Количество() = 0 Тогда
		ШаблонПричиныОшибки = 
			НСтр("ru = 'В заявке (предзаказе) клиента %1 не найден товар ""%2"" по коду позиции ""%3"".'");
		ПричинаОшибки = СтрШаблон(
			ШаблонПричиныОшибки,
			ЗаявкаКлиентаСсылка,
			ДетальнаяЗапись.ТоварнаяКатегория,
			ДетальнаяЗапись.КодПозицииЗаказа);
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	СтрокаТЧ = НайденныеСтрокиТоваровЗаявки[0];
	ДатаПодтверждения = ТекущаяДатаСеанса(); 
	Если ВозможноПодтверждениеЗаявки(ЗаявкаКлиентаОбъект, ШаблонОшибки, ТекстНачалоОшибки) Тогда
		
		СтрокаТЧ.Количество = ДетальнаяЗапись.Количество;
		
		ШаблонПримечания = НСтр("ru = '%1 Подтв: %2;'");
		Примечание = СтрШаблон(ШаблонПримечания, СтрокаТЧ.Примечание, ДатаПодтверждения);
		СтрокаТЧ.Примечание = СокрЛП(Примечание);
		
		НачатьТранзакцию();
		Попытка
			ЗаявкаКлиентаОбъект.Заблокировать();
			ЗаявкаКлиентаОбъект.ДополнительныеСвойства.Вставить(
				"ВерсионированиеОбъектовКомментарийКВерсии",
				НСтр("ru = 'АРМ Подтверждение количества в заявках (предзаказах) собственных контрагентов'"));
			ЗаявкаКлиентаОбъект.Записать(РежимЗаписиДокумента.Проведение);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ШаблонПричиныОшибки = НСтр("ru = 'Неудачная попытка провести документ %1. %2'");
			ПричинаОшибки = СтрШаблон(
				ШаблонПричиныОшибки,
				ЗаявкаКлиентаСсылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
			бг_ОбщегоНазначенияСервер.ДополнитьТекстСообщениямиПользователю(ТекстОшибки);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
			
			ЗаписьЖурналаРегистрации(
				СобытиеЖурналаРегистрацииПодтверждениеКоличества(),
				УровеньЖурналаРегистрации.Ошибка,
				ЗаявкаКлиентаСсылка.Метаданные(),
				ЗаявкаКлиентаСсылка,
				ТекстОшибки);
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьОшибкиЗаполненияСтроки(ДетальнаяЗапись, ШаблонОшибки, ТекстНачалоОшибки)
	
	ЕстьОшибкиЗаполненияСтроки = Ложь;
	
	Если Не ЗначениеЗаполнено(ДетальнаяЗапись.ЗаявкаКлиента) Тогда
		ПричинаОшибки = НСтр("ru = 'Не указана заявка (предзаказ) клиента.'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		ЕстьОшибкиЗаполненияСтроки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДетальнаяЗапись.ТоварнаяКатегория) Тогда
		ПричинаОшибки = НСтр("ru = 'Не указана товарная категория.'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		ЕстьОшибкиЗаполненияСтроки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДетальнаяЗапись.КодПозицииЗаказа) Тогда
		ПричинаОшибки = НСтр("ru = 'Не указан код позиции заявки (предзаказа) клиента.'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		ЕстьОшибкиЗаполненияСтроки = Истина;
	КонецЕсли;
	
	Возврат ЕстьОшибкиЗаполненияСтроки;
	
КонецФункции

&НаСервере
Функция ВозможноПодтверждениеЗаявки(ЗаявкаКлиентаОбъект, ШаблонОшибки, ТекстНачалоОшибки)
	
	Статус = ЗаявкаКлиентаОбъект.СтатусЗаявкиКлиентаСобственногоКонтрагента;
	
	Если Не ЗаявкаКлиентаОбъект.Проведен Тогда
		ШаблонПричиныОшибки = НСтр("ru = 'Документ %1 не проведен. Подтверждение запрещено.'");
		ПричинаОшибки = СтрШаблон(ШаблонПричиныОшибки, ЗаявкаКлиентаОбъект);
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
	ИначеЕсли Статус = Перечисления.бг_СтатусыЗаявокКлиентовСобственныхКонтрагентов.Отменена Тогда
		ШаблонПричиныОшибки = НСтр("ru = 'Документ %1 отменена. Подтверждение запрещено.'");
		ПричинаОшибки = СтрШаблон(ШаблонПричиныОшибки, ЗаявкаКлиентаОбъект);
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
	ИначеЕсли Статус = Перечисления.бг_СтатусыЗаявокКлиентовСобственныхКонтрагентов.Подтверждена Тогда
		ШаблонПричиныОшибки = НСтр("ru = 'Документ %1 уже подтверждена. Повторное подтверждение запрещено.'");
		ПричинаОшибки = СтрШаблон(ШаблонПричиныОшибки, ЗаявкаКлиентаОбъект);
		ТекстОшибки = СтрШаблон(ШаблонОшибки, ТекстНачалоОшибки, ПричинаОшибки);
	Иначе
		ТекстОшибки = "";
	КонецЕсли;
	
	ВозможноПодтверждение = ПустаяСтрока(ТекстОшибки);
	Если Не ВозможноПодтверждение Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
	Возврат ВозможноПодтверждение; 
	
КонецФункции

&НаСервере
Функция СобытиеЖурналаРегистрацииПодтверждениеКоличества()
	
	Возврат НСтр("ru = 'Подтверждение количества в заявках'");
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеДанныхДереваИОтчета

&НаСервере
Процедура ЗаполнитьПодтверждаемыеТоварыНаСервере()
	
	ПодтверждаемыеТовары.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявкиКлиентов.Ссылка КАК ЗаявкаКлиента,
	|	ЗаявкиКлиентов.Контрагент КАК Контрагент,
	|	ЗаявкиКлиентов.Организация КАК Организация,
	|	ЗаявкиКлиентов.ДатаДоставки КАК ДатаДоставки,
	|	ВЫБОР
	|		КОГДА ЗаявкиКлиентов.ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ЗаявкиКлиентов.Дата
	|		ИНАЧЕ ЗаявкиКлиентов.ДатаОтгрузки
	|	КОНЕЦ КАК ДатаОтгрузки,
	|	ВЫБОР
	|		КОГДА ЗаявкиКлиентов.ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА РАЗНОСТЬДАТ(ЗаявкиКлиентов.ДатаДоставки, ЗаявкиКлиентов.Дата, ДЕНЬ)
	|		ИНАЧЕ РАЗНОСТЬДАТ(ЗаявкиКлиентов.ДатаДоставки, ЗаявкиКлиентов.ДатаОтгрузки, ДЕНЬ)
	|	КОНЕЦ КАК СрокДоставки,
	|	ЗаявкиКлиентов.ПунктНазначения КАК ПунктРазгрузки
	|ПОМЕСТИТЬ ЗаявкиКлиентов
	|ИЗ
	|	Документ.битЗаявкаКлиента КАК ЗаявкиКлиентов
	|ГДЕ
	|	ЗаявкиКлиентов.Проведен
	|	И ЗаявкиКлиентов.ИсточникЗаказа = ЗНАЧЕНИЕ(Перечисление.бг_ИсточникиЗагрузкиЗаказовКлиентов.СобственныйКонтрагент)
	|	И ЗаявкиКлиентов.СтатусЗаявкиКлиентаСобственногоКонтрагента <> ЗНАЧЕНИЕ(Перечисление.бг_СтатусыЗаявокКлиентовСобственныхКонтрагентов.Отменена)
	|	И ВЫБОР
	|			КОГДА ЗаявкиКлиентов.ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЗаявкиКлиентов.Дата
	|			ИНАЧЕ ЗаявкиКлиентов.ДатаОтгрузки
	|		КОНЕЦ >= &НачалоПериода
	|	И ВЫБОР
	|			КОГДА ЗаявкиКлиентов.ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЗаявкиКлиентов.Дата
	|			ИНАЧЕ ЗаявкиКлиентов.ДатаОтгрузки
	|		КОНЕЦ <= &КонецПериода
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаявкаКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаявкиКлиентов.ЗаявкаКлиента КАК ЗаявкаКлиента,
	|	ЗаявкиКлиентов.Контрагент КАК Контрагент,
	|	ЗаявкиКлиентов.Контрагент.Наименование КАК КонтрагентНаименование,
	|	ЗаявкиКлиентов.Контрагент.бг_Тикер КАК КонтрагентТикер,
	|	ЗаявкиКлиентов.Организация КАК Организация,
	|	ЗаявкиКлиентов.ДатаДоставки КАК ДатаДоставки,
	|	ЗаявкиКлиентов.ДатаОтгрузки КАК ДатаОтгрузки,
	|	ЗаявкиКлиентов.СрокДоставки КАК СрокДоставки,
	|	ЗаявкиКлиентов.ПунктРазгрузки КАК ПунктРазгрузки,
	|	Товары.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	ТоварныеКатегории.Наименование КАК ТоварнаяКатегорияНаименование,
	|	ТоварныеКатегории.бг_КодНСИ КАК ТоварнаяКатегорияКодНСИ,
	|	ТоварныеКатегории.бг_КатегорияВладельца КАК КатегорияВладельца,
	|	ТоварныеКатегории.бг_Бренд КАК Бренд,
	|	Товары.КодПозицииЗаказа КАК КодПозицииЗаказа,
	|	Товары.КоличествоПервичное КАК КоличествоПервичное,
	|	Товары.Количество КАК Количество
	|ИЗ
	|	ЗаявкиКлиентов КАК ЗаявкиКлиентов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.битЗаявкаКлиента.Товары КАК Товары
	|		ПО ЗаявкиКлиентов.ЗаявкаКлиента = Товары.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТоварныеКатегории КАК ТоварныеКатегории
	|		ПО (Товары.ТоварнаяКатегория = ТоварныеКатегории.Ссылка)
	|ГДЕ
	|	&УсловиеТоварныеКатегории
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварнаяКатегорияНаименование,
	|	КонтрагентНаименование,
	|	КоличествоПервичное УБЫВ
	|ИТОГИ
	|	СУММА(КоличествоПервичное),
	|	СУММА(Количество)
	|ПО
	|	ТоварнаяКатегория";
	
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала); 
	Запрос.УстановитьПараметр("КонецПериода", Период.ДатаОкончания);
	
	Если ИспользоватьОтборТоварныхКатегорий Тогда
		СписокТоварныхКатегорий = СписокТоварныхКатегорийПоОтборуСКД();
		Запрос.УстановитьПараметр("СписокТоварныхКатегорий", СписокТоварныхКатегорий);
		ТекстЗапроса = СтрЗаменить(
			ТекстЗапроса,
			"&УсловиеТоварныеКатегории",
			"Товары.ТоварнаяКатегория В(&СписокТоварныхКатегорий)");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеТоварныеКатегории", "ИСТИНА");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	ВыборкаТоварнаяКатегория = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ТоварнаяКатегория");
	Пока ВыборкаТоварнаяКатегория.Следующий() Цикл
		СтрокаТоварнаяКатегория = ПодтверждаемыеТовары.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТоварнаяКатегория, ВыборкаТоварнаяКатегория);
		СтрокаТоварнаяКатегория.ЭтоСтрокаГруппировки = Истина;
		
		Выборка = ВыборкаТоварнаяКатегория.Выбрать();
		ПерваяДетальнаяЗапись = Истина;
		Пока Выборка.Следующий() Цикл
			Если ПерваяДетальнаяЗапись Тогда
				СтрокаТоварнаяКатегория.КатегорияВладельца = Выборка.КатегорияВладельца;
				СтрокаТоварнаяКатегория.Бренд = Выборка.Бренд;
				ПерваяДетальнаяЗапись = Ложь;
			КонецЕсли;
			ДетальнаяЗапись = СтрокаТоварнаяКатегория.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(ДетальнаяЗапись, Выборка);
		КонецЦикла;
	КонецЦикла;
	
	ЗаполнитьСлужебныеРеквизитыПодтверждаемыхТоваров();
	
	ПодтверждаемыеТоварыДеревоЗначений = ДанныеФормыВЗначение(ПодтверждаемыеТовары, Тип("ДеревоЗначений")); 
	ПодтверждаемыеТоварыДеревоЗначений.Строки.Сортировать("ТоварнаяКатегория,Контрагент,КоличествоПервичное Убыв", Истина); 
	ЗначениеВДанныеФормы(ПодтверждаемыеТоварыДеревоЗначений, ПодтверждаемыеТовары);
	
	СформироватьОтчетДляВыгрузкиВExcel();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетДляВыгрузкиВExcel() Экспорт
	
	РезультатДляВыгрузкиВExcel.Очистить();
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = ОбъектОбработки.ПолучитьМакет("МакетКомпоновкиДляВыгрузкиВExcel");
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	НастройкиОтчета = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
		ПараметрМакетОформления = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("МакетОформления");
		Если ПараметрМакетОформления.Значение = "Main" 
			Или ПараметрМакетОформления.Значение = "Основной" Тогда
			ПараметрМакетОформления.Значение = "ОформлениеОтчетовБежевый";
			ПараметрМакетОформления.Использование = Истина;
		КонецЕсли;
	
	ВнешниеНаборыДанных = Новый Структура();
	ВнешниеНаборыДанных.Вставить("ДанныеДляОтчета", ДанныеДляОтчета());
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(РезультатДляВыгрузкиВExcel);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Элементы.РезультатДляВыгрузкиВExcel.ОтображениеСостояния.Видимость = ложь; 
	Элементы.РезультатДляВыгрузкиВExcel.ОтображениеСостояния.ДополнительныйРежимОтображения = 
		ДополнительныйРежимОтображения.НеИспользовать;
	
КонецПроцедуры

&НаСервере
Функция ПустыеДанныеДляОтчета() Экспорт
	
	ДлинаКонаНСИ = Метаданные.Справочники.ТоварныеКатегории.Реквизиты["бг_КодНСИ"].Тип.КвалификаторыСтроки.Длина;
	ДлинаТикера = Метаданные.Справочники.Контрагенты.Реквизиты["бг_Тикер"].Тип.КвалификаторыСтроки.Длина;
	ДлинаНаименованияТоварнойКатегории = Метаданные.Справочники.ТоварныеКатегории.ДлинаНаименования;
	ДлинаНаименованияКонтрагента = Метаданные.Справочники.Контрагенты.ДлинаНаименования;
	
	ОписаниеТипаКоличество = ОбщегоНазначения.ОписаниеТипаЧисло(10, 0, ДопустимыйЗнак.Неотрицательный);
	
	ДанныеДляОтчета = Новый ТаблицаЗначений;
	ДанныеДляОтчета.Колонки.Добавить("ТоварнаяКатегория", Новый ОписаниеТипов("СправочникСсылка.ТоварныеКатегории"));
	ДанныеДляОтчета.Колонки.Добавить("ТоварнаяКатегорияКодНСИ", ОбщегоНазначения.ОписаниеТипаСтрока(ДлинаКонаНСИ));
	ДанныеДляОтчета.Колонки.Добавить(
		"ТоварнаяКатегорияНаименование",
		ОбщегоНазначения.ОписаниеТипаСтрока(ДлинаНаименованияТоварнойКатегории));
	ДанныеДляОтчета.Колонки.Добавить(
		"КатегорияВладельца",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_СКЮ_КатегорияВладельца"));
	ДанныеДляОтчета.Колонки.Добавить("Бренд", Новый ОписаниеТипов("СправочникСсылка.Марки"));
	ДанныеДляОтчета.Колонки.Добавить("Контрагент", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ДанныеДляОтчета.Колонки.Добавить("КонтрагентТикер", ОбщегоНазначения.ОписаниеТипаСтрока(ДлинаТикера));
	ДанныеДляОтчета.Колонки.Добавить(
		"КонтрагентНаименование",
		ОбщегоНазначения.ОписаниеТипаСтрока(ДлинаНаименованияКонтрагента));
	ДанныеДляОтчета.Колонки.Добавить("Количество", ОписаниеТипаКоличество);
	ДанныеДляОтчета.Колонки.Добавить("КоличествоПервичное", ОписаниеТипаКоличество);
	
	Возврат ДанныеДляОтчета;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПодтверждаемыхТоваров(ИдентификаторыСтрок = Неопределено)
	
	МассивСтрок = Новый Массив;
	
	Если ИдентификаторыСтрок = Неопределено Тогда
		Для Каждого СтрокаТоварнаяКатегория Из ПодтверждаемыеТовары.ПолучитьЭлементы() Цикл
			Для Каждого Строка Из СтрокаТоварнаяКатегория.ПолучитьЭлементы() Цикл
				МассивСтрок.Добавить(Строка);
			КонецЦикла;
		КонецЦикла;
	Иначе
		Если ТипЗнч(ИдентификаторыСтрок) = Тип("Массив") Тогда
			Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
				Строка = ПодтверждаемыеТовары.НайтиПоИдентификатору(ИдентификаторСтроки);
				МассивСтрок.Добавить(Строка);
			КонецЦикла;
		Иначе
			// Передан один идентификатор строки.
			Строка = ПодтверждаемыеТовары.НайтиПоИдентификатору(ИдентификаторыСтрок);
			МассивСтрок.Добавить(Строка);
		КонецЕсли; 
	КонецЕсли; 
	
	Для Каждого Строка Из МассивСтрок Цикл
		
		Строка.ЭтоСтрокаГруппировки = Ложь;
		
	КонецЦикла;
	
	ОбновитьИтоговыеСтрокиПодтверждаемыхТоваров(ИдентификаторыСтрок);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоговыеСтрокиПодтверждаемыхТоваров(ИдентификаторыСтрок = Неопределено)
	
	МассивСтрок = Новый Массив;
	
	// В Массив строк соберем строки верхнего уровня, которые надо обновить.
	Если ИдентификаторыСтрок = Неопределено Тогда
		Для Каждого СтрокаТоварнаяКатегория Из ПодтверждаемыеТовары.ПолучитьЭлементы() Цикл
			МассивСтрок.Добавить(СтрокаТоварнаяКатегория);
		КонецЦикла;
	Иначе
		Если ТипЗнч(ИдентификаторыСтрок) = Тип("Массив") Тогда
			Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
				Строка = ПодтверждаемыеТовары.НайтиПоИдентификатору(ИдентификаторСтроки);
				СтрокаТоварнаяКатегория = Строка.ПолучитьРодителя();
				МассивСтрок.Добавить(СтрокаТоварнаяКатегория);
			КонецЦикла;
		Иначе
			// Передан один идентификатор строки.
			Строка = ПодтверждаемыеТовары.НайтиПоИдентификатору(ИдентификаторыСтрок);
			СтрокаТоварнаяКатегория = Строка.ПолучитьРодителя();
			МассивСтрок.Добавить(СтрокаТоварнаяКатегория);
		КонецЕсли; 
	КонецЕсли; 
	
	Для Каждого СтрокаТоварнаяКатегория Из МассивСтрок Цикл
		
		СтрокаТоварнаяКатегория.ЭтоСтрокаГруппировки = Истина;
		
		// Сбросим суммируемые значения.
		СтрокаТоварнаяКатегория.КоличествоПервичное = 0;
		СтрокаТоварнаяКатегория.Количество = 0;
		
		// Сбросим флаги.
		СтрокаТоварнаяКатегория.КоличествоИзменено = Ложь;
		
		Для Каждого Строка Из СтрокаТоварнаяКатегория.ПолучитьЭлементы() Цикл
			
			// Суммируемые значения.
			СтрокаТоварнаяКатегория.КоличествоПервичное = 
				СтрокаТоварнаяКатегория.КоличествоПервичное + Строка.КоличествоПервичное;
			СтрокаТоварнаяКатегория.Количество = 
				СтрокаТоварнаяКатегория.Количество + Строка.Количество;
			
			// Флаги в итоговых строках установим, если есть хотя бы одна детальная строка с установленным флагом.
			Если Строка.КоличествоИзменено Тогда
				 СтрокаТоварнаяКатегория.КоличествоИзменено = Истина;
			КонецЕсли;
			 
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДанныеДляОтчета()
	
	ДанныеДляОтчета = ПустыеДанныеДляОтчета();
	
	Для Каждого СтрокаТоварнаяКатегория Из ПодтверждаемыеТовары.ПолучитьЭлементы() Цикл
		Для Каждого ДетальнаяЗапись Из СтрокаТоварнаяКатегория.ПолучитьЭлементы() Цикл
			СтрокаДанныхДляОтчета = ДанныеДляОтчета.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДанныхДляОтчета, ДетальнаяЗапись);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеДляОтчета;
	
КонецФункции

#КонецОбласти

#Область ОтборыСКД

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроекДляОтборов()
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = ОбъектОбработки.ПолучитьМакет("МакетКомпоновкиДляСерверныхОтборов");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных); 
	КомпоновщикНастроекДляОтборов.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроекДляОтборов.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроекДляОтборов.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Настройки = Новый Структура("ИспользоватьОтборТоварныхКатегорий");
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	Настройки.Вставить("ПользовательскиеНастройки", КомпоновщикНастроекДляОтборов.ПользовательскиеНастройки);
	
	Настройки.Вставить("Период", Период);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"Обработка.бг_ЖурналДокументовЗаявкиКлиентовСобственныхКонтрагентов",
		"Основная",
		Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Обработка.бг_ЖурналДокументовЗаявкиКлиентовСобственныхКонтрагентов",
		"Основная");
	
	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда
		
		КомпоновщикНастроекДляОтборов.ЗагрузитьПользовательскиеНастройки(ЗначениеНастроек.ПользовательскиеНастройки);
		КомпоновщикНастроекДляОтборов.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначениеНастроек);
		
		Если Не ЗначениеНастроек.Свойство("ИспользоватьОтборТоварныхКатегорий") Тогда
			ИспользоватьОтборТоварныхКатегорий = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СписокТоварныхКатегорийПоОтборуСКД()
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = ОбъектОбработки.ПолучитьМакет("МакетКомпоновкиДляСерверныхОтборов");
	
	//СхемаКомпоновкиДанных.НаборыДанных.Набор.Запрос = ВременнаяТаблицаСпособовОбеспечения(Параметры.ТоварыПоддерживаемогоЗапаса);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	
	Настройки = КомпоновщикНастроекДляОтборов.ПолучитьНастройки();
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Запрос = ПолучитьЗапросСОтборамиКомпоновкиДанных(АдресСхемыКомпоновкиДанных, КомпоновщикНастроек, "Набор");
	УдалитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	СписокТоварныхКатегорий = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ТоварнаяКатегория");
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СписокТоварныхКатегорий;
	
КонецФункции

&НаСервере
Функция ПолучитьЗапросСОтборамиКомпоновкиДанных(АдресСхемыКомпоновкиДанных, КомпоновщикНастроек, ИмяНабораДанных)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	ОтборКомпоновки = КомпоновщикНастроек.ПолучитьНастройки().Отбор;
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных,
		КомпоновщикНастроек.ПолучитьНастройки(),,,, Ложь);
	
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных[ИмяНабораДанных].Запрос);
	
	Для Каждого ПараметрКомпоновки Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.УстановитьПараметр(ПараметрКомпоновки.Имя, ПараметрКомпоновки.Значение);
	КонецЦикла;
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти

#Область ВыгрузкаИЗагрузкаФайловExcel

&НаКлиенте
Процедура ВыгрузитьВExcelЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;    
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ИмяФайла = ДиалогВыбораФайла.ПолноеИмяФайла;
		Попытка
			РезультатДляВыгрузкиВExcel.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.XLSX);
		Исключение
			ТекстСообщения = НСтр("ru = 'При попытке записи файла %ИмяФайла%  произошла ошибка.';
									|en = 'An error occurred when writing the %ИмяФайла% file.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяФайла%", ИмяФайла);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзExcelЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ПомещениеФайлаОтменено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.Адрес) Тогда
		ЗагрузитьИзExcelНаСервере(Результат.Адрес);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзExcelНаСервере(АдресФайла)
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.ЗагрузитьИзExcel(ЭтотОбъект, АдресФайла);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеExcelВПодтверждаемыеТовары(ДанныеЗаполнения) Экспорт
	
	ИдентификаторыИзмененныхСтрок = Новый Массив;
	ОтборСтрок = Новый Структура("ТоварнаяКатегория");
	Для Каждого СтрокаТоварнаяКатегория Из ПодтверждаемыеТовары.ПолучитьЭлементы() Цикл
		
		ТоварнаяКатегория = СтрокаТоварнаяКатегория.ТоварнаяКатегория;
		Если Не ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
			Продолжить;
		КонецЕсли;
		
		ОтборСтрок.ТоварнаяКатегория = ТоварнаяКатегория;
		НайденныеСтрокиДанныеЗаполнения = ДанныеЗаполнения.НайтиСтроки(ОтборСтрок);
		
		Если НайденныеСтрокиДанныеЗаполнения.Количество() > 0 Тогда
			РаспределитьПодтвержденноеКоличествоExcelПоЗаявкам(
				СтрокаТоварнаяКатегория,
				НайденныеСтрокиДанныеЗаполнения,
				ИдентификаторыИзмененныхСтрок);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИдентификаторыИзмененныхСтрок.Количество() > 0 Тогда
		Модифицированность = Истина;
		ЗаполнитьСлужебныеРеквизитыПодтверждаемыхТоваров(ИдентификаторыИзмененныхСтрок);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РаспределитьПодтвержденноеКоличествоExcelПоЗаявкам(СтрокаТоварнаяКатегория,
															НайденныеСтрокиДанныеЗаполнения,
															ИдентификаторыИзмененныхСтрок)
	
	Для Каждого СтрокаДанныхЗаполнения Из  НайденныеСтрокиДанныеЗаполнения Цикл
		
		ОсталосьРаспределить = СтрокаДанныхЗаполнения.Количество;
		
		Для каждого ДетальнаяЗапись Из СтрокаТоварнаяКатегория.ПолучитьЭлементы() Цикл
			
			Если НЕ ДетальнаяЗапись.Контрагент = СтрокаДанныхЗаполнения.Контрагент Тогда
				Продолжить;
			КонецЕсли;
			
			ДетальнаяЗапись.КоличествоИзменено = Истина;
			ИдентификаторыИзмененныхСтрок.Добавить(ДетальнаяЗапись.ПолучитьИдентификатор());
			
			МожноРаспределить = Мин(ДетальнаяЗапись.КоличествоПервичное, ОсталосьРаспределить);
			ДетальнаяЗапись.Количество = МожноРаспределить;
			ОсталосьРаспределить = ОсталосьРаспределить - МожноРаспределить;
			
		КонецЦикла;
		
		Если ОсталосьРаспределить <> 0 Тогда
			ШаблонОшибки = бг_ОбщегоНазначенияСервер.СтрокаБезСимволовПереноса(
				НСтр("ru = 'Данные строки %1 файла Excel.
					| Не удалось распределить по заявкам (предзаказам) контрагента ""%2"" подтвержденное
					| количество %3 товара ""%4"", нераспределенный остаток %5.'"));
			ТекстОшибки = СтрШаблон(
				ШаблонОшибки,
				СтрокаДанныхЗаполнения.НомерСтрокиФайла,
				СтрокаДанныхЗаполнения.Контрагент,
				СтрокаДанныхЗаполнения.Количество,
				СтрокаДанныхЗаполнения.ТоварнаяКатегория,
				ОсталосьРаспределить);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
 
#КонецОбласти
