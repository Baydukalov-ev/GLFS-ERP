
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		УстановитьОрганизациюЕГАИС();
		ПриПолученииДанныхНаСервере(РеквизитФормыВЗначение("Объект"));
	КонецЕсли;	
	
	ТекущийСтатусДокумента = Документы.битОтчетОбИмпортеПродукцииЕГАИС.ТекущийСтатус(Объект.Ссылка);
	Если ТекущийСтатусДокумента = Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.бг_Подтвержден И Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая()
		И Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ЗакрытьПринудительно", ЭтаФорма), "Нельзя создавать документ без документа основания");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОбновитьИнформациюОАктеСписанияЕГАИС();
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			Прочитать();
		Иначе
			ОбновитьСтатусЕГАИС();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Прочитать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) 

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом  
	ОбновитьИнформациюОАктеСписанияЕГАИС();

	ПриПолученииДанныхНаСервере(ТекущийОбъект) 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтчетОбИмпортеПродукцииЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.НомерКонтракта = СокрЛП(Объект.НомерКонтракта);
	Объект.НомерГТД = СокрЛП(Объект.НомерГТД);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = '""Отчет об импорте продукции"" не проведен. Провести?';
							|en = '""Отчет об импорте продукции"" не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = '""Отчет об импорте продукции"" был изменен. Провести?';
							|en = '""Отчет об импорте продукции"" был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьОрганизациюЕГАИС()
КонецПроцедуры

&НаКлиенте
Процедура НомерГТДПриИзменении(Элемент)
	
	СтрокаНомерГТД = Объект.НомерГТД;
	НомерНачалаДаты = СтрНайти(СтрокаНомерГТД, "/");
	Если НомерНачалаДаты > 0 Тогда
		Попытка
			ДатаИзГТД = Дата("20" + Сред(СтрокаНомерГТД, НомерНачалаДаты + 5, 2) + Сред(СтрокаНомерГТД, НомерНачалаДаты + 3, 2) + Сред(СтрокаНомерГТД, НомерНачалаДаты + 1, 2));
			Объект.ДатаГТД = ДатаИзГТД;
			Объект.ДатаИмпорта = ДатаИзГТД;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АктСписанияЕГАИСНажатие(Элемент)
	
	Если ЗначениеЗаполнено(АктСписанияЕГАИС) Тогда
		ПоказатьЗначение(, АктСписанияЕГАИС);
	Иначе  
		
		Если Модифицированность
			Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ПоказатьПредупреждение(, НСтр("ru='Для создания акта необходимо записать документ'"));
		КонецЕсли; 
		
		ОткрытьФорму("Документ.АктСписанияЕГАИС.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения", 
				Новый Структура("бг_ОтчетОбИмпортеПродукции", Объект.Ссылка)),
			,
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыАлкогольнаяПродукцияПриИзменении(Элемент)
	ТоварыАлкогольнаяПродукцияПриИзмененииНаСервере()
КонецПроцедуры

&НаСервере
Процедура ТоварыАлкогольнаяПродукцияПриИзмененииНаСервере()
	
	ПолучитьКрепостьДляСтрокиТовара(Элементы.Товары.ТекущаяСтрока); 
	ОбновитьВторичныеДанныеТовараНаСервере(Элементы.Товары.ТекущаяСтрока);
	РассчитатьОбъемДал();

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные; 
	ТекущиеДанные.НомерПартии = Строка(ТекущиеДанные.Серия.УникальныйИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	РассчитатьОбъемДал();

КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр ИЛИ ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(Элементы, "СтраницаТовары", "ТолькоПросмотр") Тогда
		СсылкаНаЗначение = Объект.Товары[ВыбраннаяСтрока][Прав(Поле.Имя, СтрДлина(Поле.Имя) - 6)];
		Если ЗначениеЗаполнено(СсылкаНаЗначение) Тогда
			ПоказатьЗначение(,СсылкаНаЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	РассчитатьОбъемДал();

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент) 
	
	УстановитьВидимостьГиперссылкиНаСозданиеАктаСписанияЕГАИС(); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапроситьСправки1(Команда)
	
	АдресВоВременномХранилище = ЗапросыСправок1ВоВременномХранилище();
	Если АдресВоВременномХранилище = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапросаСправок = Новый Структура;
	ПараметрыЗапросаСправок.Вставить("Операция",             ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросСправки1"));
	ПараметрыЗапросаСправок.Вставить("АдресМассиваЗапросов", АдресВоВременномХранилище);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыЗапросаСправок,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ЗарегистрироватьДокументКВыгрузке();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьСправки2(Команда)
	
	АдресВоВременномХранилище = ЗапросыСправок2ВоВременномХранилище();
	Если АдресВоВременномХранилище = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапросаСправок = Новый Структура;
	ПараметрыЗапросаСправок.Вставить("Операция",             ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросСправки2"));
	ПараметрыЗапросаСправок.Вставить("АдресМассиваЗапросов", АдресВоВременномХранилище);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыЗапросаСправок,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ЗарегистрироватьДокументКВыгрузке();
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОрганизациюЕГАИС()
	Объект.ОрганизацияЕГАИС = Документы.битОтчетОбИмпортеПродукцииЕГАИС.ОрганизацияЕГАИС(Объект.Организация)
КонецПроцедуры	

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ОбновитьВторичныеДанныеТоваровНаСервере(ТекущийОбъект);
	ОбновитьСтатусЕГАИС();	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеТовараНаСервере(Идентификатор)
	
	Товар = Объект.Товары.НайтиПоИдентификатору(Идентификатор);

	КодЕГАИС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Товар.АлкогольнаяПродукция, "Код"); 
	ОбновитьВторичныеДанныеТовара(Товар, КодЕГАИС)
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеТоваровНаСервере(ТекущийОбъект)
	
	КодЕГАИСПродукции = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
			ТекущийОбъект.Товары.ВыгрузитьКолонку("АлкогольнаяПродукция"), 
			"Код"); 
	
	Для Каждого Товар Из Объект.Товары Цикл
		ОбновитьВторичныеДанныеТовара(Товар, КодЕГАИСПродукции[Товар.АлкогольнаяПродукция])
	КонецЦикла;
	
	РассчитатьОбъемДал();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКрепостьДляСтрокиТовара(Идентификатор)
	
	Товар = Объект.Товары.НайтиПоИдентификатору(Идентификатор);
	Крепость = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Товар.АлкогольнаяПродукция, "Крепость");
	Товар.Крепость = Крепость;
	Товар.КрепостьМин = Крепость;
	Товар.КрепостьМакс = Крепость;
	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВторичныеДанныеТовара(Товар, Знач КодЕГАИС)
	Товар.КодЕГАИС = ?(ЗначениеЗаполнено(КодЕГАИС), КодЕГАИС, "");
КонецПроцедуры

&НаСервере
Процедура РассчитатьОбъемДал()
	
	ОбъемДал = 0;
	
	СвойстваАлкогольнойПродукции = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
	Объект.Товары.Выгрузить(, "АлкогольнаяПродукция").ВыгрузитьКолонку("АлкогольнаяПродукция"),
	"ТипПродукции, Объем");

	Для Каждого Строка из Объект.Товары Цикл
		
		Если Не ЗначениеЗаполнено(Строка.АлкогольнаяПродукция) Тогда
			Продолжить;
		КонецЕсли;
		
		ТипПродукцииСтроки = СвойстваАлкогольнойПродукции[Строка.АлкогольнаяПродукция].ТипПродукции;
		ОбъемПродукцииСтроки = СвойстваАлкогольнойПродукции[Строка.АлкогольнаяПродукция].Объем;
		
		Если ТипПродукцииСтроки = Перечисления.ТипыПродукцииЕГАИС.Неупакованная ИЛИ (ТипПродукцииСтроки = Перечисления.ТипыПродукцииЕГАИС.ПустаяСсылка() И ОбъемПродукцииСтроки = 0) Тогда
			ОбъемДал = ОбъемДал + Строка.Количество;
		Иначе
			ОбъемДал = ОбъемДал + Строка.Количество * ОбъемПродукцииСтроки / 10;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОАктеСписанияЕГАИС()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	АктСписанияЕГАИС.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.АктСписанияЕГАИС КАК АктСписанияЕГАИС
		|ГДЕ
		|	АктСписанияЕГАИС.бг_ОтчетОбИмпортеПродукции = &Ссылка
		|	И НЕ АктСписанияЕГАИС.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			АктСписанияЕГАИС = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьВидимостьГиперссылкиНаСозданиеАктаСписанияЕГАИС();	
	
КонецПроцедуры    

&НаСервере
Процедура УстановитьВидимостьГиперссылкиНаСозданиеАктаСписанияЕГАИС()  
	
	Если ЗначениеЗаполнено(АктСписанияЕГАИС) Тогда   
		
		Элементы.АктСписанияЕГАИС.Заголовок = НСтр(СтрШаблон("ru='Открыть документ %1'", АктСписанияЕГАИС)); 
		Элементы.АктСписанияЕГАИС.Видимость = Истина;
		
	Иначе
		Элементы.АктСписанияЕГАИС.Заголовок = НСтр("ru='<Создать акт списания ЕГАИС...>'"); 
		Элементы.АктСписанияЕГАИС.Видимость = ЕстьАроматизаторы();
		
	КонецЕсли; 
	
КонецПроцедуры  

&НаСервере
Функция ЕстьАроматизаторы()  
	
	МассивТоваров = Объект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура");

	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("МассивТоваров", МассивТоваров);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.бг_ТипИмпортныхССП = ЗНАЧЕНИЕ(Перечисление.бг_ТипыИмпортныхССП.Ароматизитор)
	|	И Номенклатура.Ссылка В(&МассивТоваров)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	СтатусЕГАИС        = МенеджерОбъекта.СтатусПоУмолчанию();
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовЕГАИС КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияЕГАИС.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусЕГАИС = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеПередачуДанных);
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(
		СтатусЕГАИС,
		ДальнейшееДействие,
		ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусЕГАИС <> Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.КПередаче
	                              И СтатусЕГАИС <> Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачи;
	
	Элементы.СтраницаОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	Элементы.СтраницаТовары.ТолькоПросмотр   = РедактированиеФормыНеДоступно;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ИнтеграцияЕГАИСКлиент.ПодготовитьКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные"),
			ЭтотОбъект.УникальныйИдентификатор);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Документ", Объект.Ссылка);
		ОткрытьФорму("Справочник.ЕГАИСПрисоединенныеФайлы.Форма.ФормаОшибки", ПараметрыОткрытияФормы, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	КонецЕсли;
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапросыСправок1ВоВременномХранилище()
	
	МассивНомеровСправок    = Новый Массив;
	МассивПараметровЗапроса = Новый Массив;
	
	Для каждого СтрокаТовара Из Объект.Товары Цикл
		Если ЗначениеЗаполнено(СтрокаТовара.Справка2) Тогда
			НомерСправки1 = СтрокаТовара.Справка2.НомерСправки1;
			
			Если МассивНомеровСправок.Найти(НомерСправки1) = Неопределено Тогда
				МассивНомеровСправок.Добавить(НомерСправки1);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого Строка Из МассивНомеровСправок Цикл
		
		ЗначенияПараметров = Новый Структура("Операция, ИмяПараметра, ЗначениеПараметра, ПредставлениеПараметра");
		ЗначенияПараметров.Вставить("Операция",               ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросСправки1"));
		ЗначенияПараметров.Вставить("ИмяПараметра",           "НомерСправки");
		ЗначенияПараметров.Вставить("ЗначениеПараметра",      Строка);
		ЗначенияПараметров.Вставить("ПредставлениеПараметра", НСтр("ru = 'Номер справки';
																   |en = 'Номер справки'"));
		
		МассивПараметровЗапроса.Добавить(ЗначенияПараметров);
		
	КонецЦикла;
	
	Если МассивПараметровЗапроса.Количество() > 0 Тогда
		Возврат ПоместитьВоВременноеХранилище(МассивПараметровЗапроса, УникальныйИдентификатор);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗапросыСправок2ВоВременномХранилище()
	
	МассивНомеровСправок    = Новый Массив;
	МассивПараметровЗапроса = Новый Массив;
	
	Для каждого СтрокаТовара Из Объект.Товары Цикл
		Если ЗначениеЗаполнено(СтрокаТовара.Справка2) Тогда
			НомерСправки = СтрокаТовара.Справка2.РегистрационныйНомер;
			
			Если МассивНомеровСправок.Найти(НомерСправки) = Неопределено Тогда
				МассивНомеровСправок.Добавить(НомерСправки);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого Строка Из МассивНомеровСправок Цикл
		
		ЗначенияПараметров = Новый Структура("Операция, ИмяПараметра, ЗначениеПараметра, ПредставлениеПараметра");
		ЗначенияПараметров.Вставить("Операция",               ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросСправки2"));
		ЗначенияПараметров.Вставить("ИмяПараметра",           "НомерСправки");
		ЗначенияПараметров.Вставить("ЗначениеПараметра",      Строка);
		ЗначенияПараметров.Вставить("ПредставлениеПараметра", НСтр("ru = 'Номер справки';
																	|en = 'Номер справки'"));
		
		МассивПараметровЗапроса.Добавить(ЗначенияПараметров);
		
	КонецЦикла;
	
	Если МассивПараметровЗапроса.Количество() > 0 Тогда
		Возврат ПоместитьВоВременноеХранилище(МассивПараметровЗапроса, УникальныйИдентификатор);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗарегистрироватьДокументКВыгрузке()

	Перем адаптер_ПодпискиНаСобытияВызовСервера; // Используем модуль из расширения БИТMDT, обходим ошибки синтакс-проверки.
	адаптер_ПодпискиНаСобытияВызовСервера = ОбщегоНазначения.ОбщийМодуль("адаптер_ПодпискиНаСобытияВызовСервера");
	
	адаптер_ПодпискиНаСобытияВызовСервера.ЗарегистрироватьИсходящееСообщение(Объект.Ссылка, Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПринудительно(ДополнительныеПараметры) Экспорт
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
