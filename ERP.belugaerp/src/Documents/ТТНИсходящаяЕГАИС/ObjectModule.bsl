
#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	бг_УстановитьТоварВПутиПринадлежитГрузополучателю(ДанныеЗаполнения);
	
КонецПроцедуры

&ИзменениеИКонтроль("ОбработкаПроверкиЗаполнения")
Процедура бг_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Отправка данных на самого себя портит данные регистра Акцизные марки ЕГАИС
	Если Грузоотправитель = Грузополучатель Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Грузополучатель должен отличаться от грузоотправителя.';
				|en = 'Грузополучатель должен отличаться от грузоотправителя.'"),
			ЭтотОбъект,
			"Грузополучатель",,
			Отказ);
		
	КонецЕсли;
	
#Удаление
	Если Дата >= '20180701' Тогда
		АкцизныеМаркиЕГАИС.ПроверитьЗаполнениеАкцизныхМарокТТНИсходящейЕГАИС(ЭтотОбъект, Отказ);
	КонецЕсли;
#КонецУдаления
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	бг_ПроверитьЗаполнениеДатыОтгрузки(РежимЗаписи, Отказ);
	бг_ПроверитьВозможностьУдаленияПроведения(РежимЗаписи, Отказ);
	бг_ПроверитьЗаполнениеТранспортногоРаздела(РежимЗаписи, Отказ);

КонецПроцедуры

&ИзменениеИКонтроль("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ТТНИсходящаяЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
#Вставка	
	// Снимаем флаги автоматической записи, чтобы вызываемый ниже метод ИнтеграцияИС.ЗаписатьНаборыЗаписей()
	// не вызывал дополнительную запись пустых наборов регистров марок, которые лишний раз будут выгружаться в WMS. 
	Движения.бг_ДвижениеМарок.Записывать = Ложь;
	
	бг_ЗафиксироватьДатуНачисленияАкциза(Отказ);
#КонецВставки	
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
#Вставка
	бг_ИнициализироватьДополнительныеСвойстваДляПроведенияПоМаркам();
	бг_СформироватьДвиженияПоМаркам(Отказ);
	бг_ОтразитьДополнительныеСведенияЗаказаКлиента(Отказ);
#КонецВставки
	
КонецПроцедуры

&После("ОбработкаУдаленияПроведения")
Процедура бг_ОбработкаУдаленияПроведения(Отказ)
	
	бг_ОтразитьДополнительныеСведенияЗаказаКлиента(Отказ);
	
КонецПроцедуры

&После("ПриЗаписи")
Процедура бг_ПриЗаписи(Отказ)
	
	бг_СформироватьДвиженияПоРееструДокументов(Отказ, Ссылка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_ЗафиксироватьДатуНачисленияАкциза(Отказ)
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(бг_ДатаФиксацииЕГАИС) Тогда 
		бг_СоздатьСправки2ПокупателяЗафиксироватьДатуНачисленияАкциза();
	КонецЕсли;
КонецПроцедуры

Процедура бг_СоздатьСправки2ПокупателяЗафиксироватьДатуНачисленияАкциза()
	ДатаНачисленияАкциза = бг_ДатаФиксацииЕГАИС;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	isnull(Справки2ЕГАИС.Ссылка, Неопределено) КАК Справка2Покупателя,
	|	ТТНИсходящаяЕГАИСТовары.Справка2 КАК Справка2,
	|	ЕСТЬNULL(ТТНИсходящаяЕГАИСТовары.Справка2.Справка1.Грузоотправитель.СоответствуетОрганизации, ЛОЖЬ) КАК УстанавливатьДату,
	|	ТТНИсходящаяЕГАИСТовары.Справка2.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТТНИсходящаяЕГАИСТовары.Справка2.НомерСправки1 КАК НомерСправки1,
	|	ТТНИсходящаяЕГАИСТовары.Справка2.Справка1 КАК Справка1,
	|	ТТНИсходящаяЕГАИСТовары.Количество КАК Количество,
	|	ТТНИсходящаяЕГАИСТовары.Справка2.бг_ДатаНачисленияАкциза КАК бг_ДатаНачисленияАкциза,
	|	ТТНИсходящаяЕГАИСТовары.НомерСправки2Покупателя КАК РегистрационныйНомер,
	|	ТТНИсходящаяЕГАИСТовары.НомерСправки2Покупателя КАК Наименование
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ТТНИсходящаяЕГАИСТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	|		ПО ТТНИсходящаяЕГАИСТовары.НомерСправки2Покупателя = Справки2ЕГАИС.РегистрационныйНомер
	|ГДЕ
	|	isnull(Справки2ЕГАИС.бг_ДатаНачисленияАкциза, ДатаВремя(1, 1, 1)) = ДатаВремя(1, 1, 1)
	|	И НЕ НомерСправки2Покупателя = """"";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	    Попытка
			Если ЗначениеЗаполнено(Выборка.Справка2Покупателя) Тогда
				Справка2Объект = Выборка.Справка2Покупателя.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(Справка2Объект, Выборка, "бг_ДатаНачисленияАкциза");
			Иначе 
				Справка2Объект = Справочники.Справки2ЕГАИС.СоздатьЭлемент();
				ЗаполнитьЗначенияСвойств(Справка2Объект, Выборка);
			КонецЕсли;
			Если Выборка.УстанавливатьДату и Не ЗначениеЗаполнено(Справка2Объект.бг_ДатаНачисленияАкциза) Тогда
				Справка2Объект.бг_ДатаНачисленияАкциза = ДатаНачисленияАкциза;
			КонецЕсли;        
			Справка2Объект.Записать();
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось создать справку 2 покупателя %1 по причине %2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.РегистрационныйНомер, ОписаниеОшибки());
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

Процедура бг_ПроверитьЗаполнениеДатыОтгрузки(РежимЗаписи, Отказ)
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или ПометкаУдаления Тогда
		
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("адаптер_ЭтоЗагрузкаДанных")
		И ДополнительныеСвойства.адаптер_ЭтоЗагрузкаДанных = Истина Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОтгрузки) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Не заполнена дата отгрузки'"), 
			ЭтотОбъект,
			"ДатаОтгрузки",
			, // ПутьКДанным
			Отказ);
			
	Иначе
			
		Если ЭтоНовый()
			И ЗначениеЗаполнено(ДатаОтгрузки)
			И НачалоДня(ДатаОтгрузки) < НачалоДня(ТекущаяДатаСеанса()) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='Дата отгрузки в создаваемой ТТН не должна быть меньше текущей даты.'"), 
				ЭтотОбъект,
				"ДатаОтгрузки",
				, // ПутьКДанным
				Отказ);
				
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура бг_ПроверитьВозможностьУдаленияПроведения(РежимЗаписи, Отказ)
	
	Если Не ЗначениеЗаполнено(Ссылка) Или Отказ Или РольДоступна("бг_КонтролерЕГАИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если РегистрыСведений.СтатусыДокументовЕГАИС.ТекущееСостояние(Ссылка).Статус
		<> Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.Подтвержден Тогда

		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или ПометкаУдаления И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='У вас недостаточно прав на отмену подтвержденной ТТН.'"),,,, Отказ);
				
	КонецЕсли;

КонецПроцедуры

Процедура бг_ПроверитьЗаполнениеТранспортногоРаздела(РежимЗаписи, Отказ)
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или ПометкаУдаления Тогда		
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("адаптер_ЭтоЗагрузкаДанных")
		И ДополнительныеСвойства.адаптер_ЭтоЗагрузкаДанных = Истина Тогда 	
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Перевозчик)
			Или Не ЗначениеЗаполнено(Заказчик)
        			Или Не ЗначениеЗаполнено(ПунктПогрузки)
       	 		Или Не ЗначениеЗаполнено(ПунктРазгрузки) Тогда
          	
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Не вся транспортная информация указана'"), 
			ЭтотОбъект,,,
			Отказ);
			
	ИначеЕсли ТипТранспорта = ПредопределенноеЗначение("Перечисление.ТипыТранспортаЕГАИС.Автомобиль")
				И(Не ЗначениеЗаполнено(Водитель)
					Или Не ЗначениеЗаполнено(Заказчик)) Тогда
				
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Не вся транспортная информация указана'"), 
			ЭтотОбъект,,,
			Отказ);
			
	КонецЕсли;

КонецПроцедуры

Процедура бг_УстановитьТоварВПутиПринадлежитГрузополучателю(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.ЗаказКлиента) Тогда
		бг_УсловияПоставки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			ДанныеЗаполнения.ЗаказКлиента,
			"бг_УсловияПоставки");
		Если ЗначениеЗаполнено(бг_УсловияПоставки) Тогда
			 ТоварВПутиПринадлежитГрузополучателюИзУсловийПоставки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				бг_УсловияПоставки,
				"ТоварВПутиПринадлежитГрузополучателю");
			Если ТоварВПутиПринадлежитГрузополучателюИзУсловийПоставки Тогда
             	ТоварВПутиПринадлежитГрузополучателю = ТоварВПутиПринадлежитГрузополучателюИзУсловийПоставки;
				Возврат;
			КонецЕсли;			
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бг_ВидыПеревозки.Самовывоз КАК Самовывоз
	|ИЗ
	|	РегистрСведений.бг_ТранспортнаяИнформация КАК бг_ТранспортнаяИнформация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.бг_ВидыПеревозки КАК бг_ВидыПеревозки
	|		ПО бг_ТранспортнаяИнформация.ВидПеревозки = бг_ВидыПеревозки.Ссылка
	|ГДЕ
	|	бг_ТранспортнаяИнформация.Объект = &Объект
	|	И бг_ВидыПеревозки.Самовывоз";
	
	Запрос.УстановитьПараметр("Объект", ДанныеЗаполнения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		ТоварВПутиПринадлежитГрузополучателю = Истина;	
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ОтразитьДополнительныеСведенияЗаказаКлиента(Отказ)
	
	Если Отказ
		Или ДополнительныеСвойства.Свойство("бг_НеРегистрироватьПоказателиЗаказаКлиентаКОбновлению")
		И ДополнительныеСвойства.бг_НеРегистрироватьПоказателиЗаказаКлиентаКОбновлению = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		ЗаказКлиента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ЗаказКлиента");
		
		Если ЗначениеЗаполнено(ЗаказКлиента) Тогда
			РегистрыСведений.бг_ОбъектыДляОтложеннойОбработки.ДобавитьОбъект(
				ЗаказКлиента,
				Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.ОтразитьДополнительныеСведенияЗаказаКлиента,,
				Новый ХранилищеЗначения(
					РегистрыСведений.бг_ДополнительныеСведенияПоЗаказамКлиентов.ПоказателиПоТипуДокумента(Ссылка)));
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

#Область ДвиженияПоМаркам

Процедура бг_ИнициализироватьДополнительныеСвойстваДляПроведенияПоМаркам()

	// бг_ТекущийСтатус
	ТекущийСтатус = РегистрыСведений.СтатусыДокументовЕГАИС.ТекущееСостояние(Ссылка).Статус;
	ДополнительныеСвойства.Вставить("бг_ТекущийСтатус",	ТекущийСтатус);
		
	// бг_ФормироватьДвиженияПоМаркам
	ФормироватьДвиженияПоМаркам	= бг_ИнтеграцияЕГАИСПовтИсп.ИспользоватьМеханизмДвиженийМарок(Ссылка);
	ДополнительныеСвойства.Вставить("бг_ФормироватьДвиженияПоМаркам", ФормироватьДвиженияПоМаркам);
	
КонецПроцедуры

Процедура бг_СформироватьДвиженияПоМаркам(Отказ)
	
	Если Отказ Или Не ДополнительныеСвойства.бг_ФормироватьДвиженияПоМаркам Тогда
		Возврат;
	КонецЕсли;

	Если Документы.ТТНИсходящаяЕГАИС.бг_СтатусДостаточныйДляФормированияМарок(ДополнительныеСвойства.бг_ТекущийСтатус) Тогда

		ДанныеОтгружаемыхШтрихкодов = Документы.ТТНИсходящаяЕГАИС.бг_ДанныеОтгружаемыхШтрихкодов(
			Ссылка,
			ДокументОснование,
			Ложь);
			
		бг_ПроверитьСоответствиеМарокТоварам(Отказ, ДанныеОтгружаемыхШтрихкодов);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Если ЕстьРасхождения Тогда
			НеподтвержденныеМарки = Документы.ТТНИсходящаяЕГАИС.НеподтвержденныеАкцизныеМарки(Ссылка);
		КонецЕсли;
		
		бг_ОтразитьДвиженияМарок(ДанныеОтгружаемыхШтрихкодов.Марки, НеподтвержденныеМарки);
		
	Иначе		
		
		Движения.бг_ДвижениеМарок.Очистить();
		Движения.бг_ДвижениеМарок.Записать();
		
	КонецЕсли;		
		
КонецПроцедуры

Процедура бг_ПроверитьСоответствиеМарокТоварам(Отказ, ДанныеОтгружаемыхШтрихкодов)
	
	Если ДанныеОтгружаемыхШтрихкодов = Неопределено Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Не найдены данные отгружаемых марок, проведение невозможно.'"),
			Ссылка,
			, // Поле
			, // ПутьКДаным
			Отказ);
			
		Возврат;	
	КонецЕсли;	
	
	Документы.ТТНИсходящаяЕГАИС.бг_МаркиСоответствуютАлкогольнойПродукцииТТН(
		ДанныеОтгружаемыхШтрихкодов.Марки,
		Ссылка,
		Отказ);	
		
КонецПроцедуры

Процедура бг_ОтразитьДвиженияМарок(Марки, НеподтвержденныеМарки)

	СтатусыМарокПоОперации = Перечисления.бг_СтатусыАкцизныхМарок.СтатусыПоОперации(Метаданные().Имя);
	СтатусОтгружаетсяОбработаноЕГАИС = СтатусыМарокПоОперации.СтатусОтгружаетсяОбработаноЕГАИС;
	СтатусМаркиВыбыла = СтатусыМарокПоОперации.СтатусВыбыла;
	СтатусМаркиОтгрузкаНеПодтверждена = СтатусыМарокПоОперации.СтатусОтгрузкаНеПодтверждена;
	
	ДатаДвиженияМарок = Документы.ТТНИсходящаяЕГАИС.бг_ДатаДвиженияМарок(
		Ссылка,
		ДокументОснование,
		Дата,
		ДатаРегистрацииДвижений);
	
	Для каждого СтрокаМарки Из Марки Цикл
		
		Запись = Движения.бг_ДвижениеМарок.Добавить();
		Запись.Период = ДатаДвиженияМарок;
		ЗаполнитьЗначенияСвойств(Запись, СтрокаМарки);
		
		Если ДополнительныеСвойства.бг_ТекущийСтатус = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОбрабатываетсяКлиентом Тогда
			Запись.СтатусМарки = СтатусОтгружаетсяОбработаноЕГАИС;
		Иначе
			Если ЕстьРасхождения И НеподтвержденныеМарки.Получить(СтрокаМарки.ИдентификаторМарки) <> Неопределено Тогда
				Запись.СтатусМарки = СтатусМаркиОтгрузкаНеПодтверждена;
			Иначе
				Запись.СтатусМарки = СтатусМаркиВыбыла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Движения.бг_ДвижениеМарок.Записать();
	
КонецПроцедуры

#КонецОбласти // Конец ДвиженияПоМаркам

# Область ДвиженияПоРееструДокументов

Процедура бг_СформироватьДвиженияПоРееструДокументов(Отказ, Документ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТТНИсходящаяЕГАИС", Документ); 
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНИсходящаяЕГАИС.Номер КАК Номер,
	|	ТТНИсходящаяЕГАИС.Дата КАК Дата,
	|	ТТНИсходящаяЕГАИС.Ссылка КАК Ссылка,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.Организация КАК Организация,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.Подразделение КАК Подразделение,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.Партнер КАК Партнер,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.Склад КАК Склад,
	|	ТТНИсходящаяЕГАИС.ПометкаУдаления КАК ПометкаУдаления,
	|	ТТНИсходящаяЕГАИС.Проведен КАК Проведен,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.Валюта КАК ДокументОснованиеВалюта,
	|	ТТНИсходящаяЕГАИС.ДокументОснование.СуммаДокумента КАК ДокументОснованиеСуммаДокумента
	|ПОМЕСТИТЬ ВТ_ТТНИсходящаяЕГАИС
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка, 
    |   Склад
	|;  
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТТНИсходящаяЕГАИС.Номер КАК НомерДокументаИБ,
	|	ВТ_ТТНИсходящаяЕГАИС.Дата КАК ДатаДокументаИБ,
	|	ВТ_ТТНИсходящаяЕГАИС.Ссылка КАК Ссылка,
	|	ВТ_ТТНИсходящаяЕГАИС.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ВТ_ТТНИсходящаяЕГАИС.Организация КАК Организация,
	|	ВТ_ТТНИсходящаяЕГАИС.Подразделение КАК Подразделение,
	|	ВТ_ТТНИсходящаяЕГАИС.Партнер КАК Партнер,
	|	КлючиРеестраДокументов.Ссылка КАК МестоХранения,
	|	ВТ_ТТНИсходящаяЕГАИС.ПометкаУдаления КАК ПометкаУдаления,
	|	ВТ_ТТНИсходящаяЕГАИС.Проведен КАК Проведен,
	|	ВТ_ТТНИсходящаяЕГАИС.ДокументОснованиеВалюта КАК Валюта,
	|	ВТ_ТТНИсходящаяЕГАИС.ДокументОснованиеСуммаДокумента КАК Сумма
	|ИЗ
	|	ВТ_ТТНИсходящаяЕГАИС КАК ВТ_ТТНИсходящаяЕГАИС
	|		Внутреннее СОЕДИНЕНИЕ Справочник.КлючиРеестраДокументов КАК КлючиРеестраДокументов
	|		ПО (КлючиРеестраДокументов.Ключ = ВТ_ТТНИсходящаяЕГАИС.Склад)
	|ГДЕ
	|	ВТ_ТТНИсходящаяЕГАИС.Ссылка = &ТТНИсходящаяЕГАИС";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() > 0 Тогда
		
		РеквизитыДокумента = ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат)[0];
		НаборЗаписей = РегистрыСведений.РеестрДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Ссылка.Установить(Документ);  
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, РеквизитыДокумента);
		НоваяЗапись.ТипСсылки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Документ)); 
		НаборЗаписей.Записать(Истина); 
		
	КонецЕсли;
 	
КонецПроцедуры

# КонецОбласти // Конец ДвиженияПоРееструДокументов  

#КонецОбласти
