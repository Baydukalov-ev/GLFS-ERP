#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Реквизиты = ВыгружаемыеРеквизиты(); 

	адаптер_НастройкиОбмена.УстановитьРеквизиты(
		РеквизитыИСвойства, 
		РеквизитыИСвойства.МетаданныеОбъекта, 
		Реквизиты);
	
	ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства);
	ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства);
					
КонецПроцедуры

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_обработчикиСобытийСтандартный;
	адаптер_обработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_обработчикиСобытийСтандартный");
	
	ДанныеОбъекта = адаптер_обработчикиСобытийСтандартный.ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения);
	
	ДополнитьДанныеВыгружаемогоОбъекта(Объект, ДанныеОбъекта);
	
	Возврат ДанныеОбъекта;
	
КонецФункции

Процедура ДополнитьДанныеВыгружаемогоОбъекта(Объект, ДанныеОбъекта) Экспорт

	РеквизитыОбъекта = ДанныеОбъекта.Реквизиты[0];
	
	Если    Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоКредитам
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаЗаймов
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеНаДепозиты
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам Тогда

		Для каждого СтрокаПлатежа Из РеквизитыОбъекта.РасшифровкаПлатежа Цикл
			
			Если  СтрокаПлатежа.Свойство("ДоговорКредитаДепозита")
				И ЗначениеЗаполнено(СтрокаПлатежа.ДоговорКредитаДепозита)
				И СтрокаПлатежа.ДоговорКредитаДепозита.Свойство("ГруппаФинансовогоУчета")
				И ЗначениеЗаполнено(СтрокаПлатежа.ДоговорКредитаДепозита.ГруппаФинансовогоУчета) Тогда
				
				// Заполнение счета учета на основании ГФУ
				ГруппаФинансовогоУчетаИдентификатор = СтрокаПлатежа.ДоговорКредитаДепозита.ГруппаФинансовогоУчета.Идентификатор;
				ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьСсылку(Новый УникальныйИдентификатор(ГруппаФинансовогоУчетаИдентификатор));
				
				СчетаУчета = Новый Массив;
				СчетаУчета.Добавить("РасчетыСДебиторамиОсновнойДолг");
				СчетаУчета.Добавить("РасчетыСДебиторамиПроценты");
				СчетаУчета.Добавить("РасчетыСДебиторамиКомиссия");
				СчетаУчета.Добавить("РасчетыСКредиторамиОсновнойДолг");
				СчетаУчета.Добавить("РасчетыСКредиторамиПроценты");
				СчетаУчета.Добавить("РасчетыСКредиторамиКомиссия");
				СчетаУчета.Добавить("РасчетыСКлиентами");

				ТипыРасчетов = Новый Массив;
				ТипыРасчетов.Добавить("РасчетыСДебиторами");
				ТипыРасчетов.Добавить("РасчетыСКредиторами");
				ТипыРасчетов.Добавить("РасчетыСКлиентами");
				
				// ТипСуммы
				ТипСуммы = "ОсновнойДолг";
				Если СтрокаПлатежа.Свойство("ТипСуммыКредитаДепозита") Тогда
					ТипСуммы = СтрокаПлатежа.ТипСуммыКредитаДепозита.ЗначениеПеречисления;
				КонецЕсли;
				
				ЗаполнитьСчетаУчетаНаОснованииГФУ(СтрокаПлатежа, ГруппаФинансовогоУчета, СчетаУчета, ТипыРасчетов, ТипСуммы);
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств Тогда

		Для каждого СтрокаПлатежа Из РеквизитыОбъекта.РасшифровкаПлатежа Цикл
			
			Если СтрокаПлатежа.Свойство("СтатьяДоходов") Тогда
				СтатьяДоходовРасходов = СтрокаПлатежа.СтатьяДоходов;
			ИначеЕсли СтрокаПлатежа.Свойство("СтатьяРасходов") Тогда
				СтатьяДоходовРасходов = СтрокаПлатежа.СтатьяРасходов;
			Иначе
				Продолжить;
			КонецЕсли;
			
			// Заполнение счета учета на основании ГФУ
			Если  СтатьяДоходовРасходов.Свойство("ГруппаФинансовогоУчетаРегл")
				И ЗначениеЗаполнено(СтатьяДоходовРасходов.ГруппаФинансовогоУчетаРегл) Тогда
				
				ГруппаФинансовогоУчетаИдентификатор = СтатьяДоходовРасходов.ГруппаФинансовогоУчетаРегл.Идентификатор;
				ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаДоходовРасходов.ПолучитьСсылку(Новый УникальныйИдентификатор(ГруппаФинансовогоУчетаИдентификатор));
				
				СчетаУчета = Новый Массив;
				СчетаУчета.Добавить("Доходы");
				СчетаУчета.Добавить("Расходы");
				
				ЗаполнитьСчетаУчетаНаОснованииГФУ(СтрокаПлатежа, ГруппаФинансовогоУчета, СчетаУчета);
				
			ИначеЕсли  СтатьяДоходовРасходов.Свойство("ГруппаФинансовогоУчета")
				И ЗначениеЗаполнено(СтатьяДоходовРасходов.ГруппаФинансовогоУчета) Тогда
				
				ГруппаФинансовогоУчетаИдентификатор = СтатьяДоходовРасходов.ГруппаФинансовогоУчета.Идентификатор;
				ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаДоходовРасходов.ПолучитьСсылку(Новый УникальныйИдентификатор(ГруппаФинансовогоУчетаИдентификатор));

				СчетаУчета = Новый Массив;
				СчетаУчета.Добавить("Доходы");
				СчетаУчета.Добавить("Расходы");
				
				ЗаполнитьСчетаУчетаНаОснованииГФУ(СтрокаПлатежа, ГруппаФинансовогоУчета, СчетаУчета);
				
			КонецЕсли;
			
		КонецЦикла;
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
		
		СтруктураГФУ = Неопределено;
		Если РеквизитыОбъекта.Свойство("ГруппаФинансовогоУчета", СтруктураГФУ)
			И ЗначениеЗаполнено(СтруктураГФУ) Тогда
			
			ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьСсылку(
				Новый УникальныйИдентификатор(СтруктураГФУ.Идентификатор));
			
			СчетаУчета = Новый Массив;
			СчетаУчета.Добавить("РасчетыСДебиторамиОсновнойДолг");
			СчетаУчета.Добавить("РасчетыСДебиторамиПроценты");
			СчетаУчета.Добавить("РасчетыСДебиторамиКомиссия");
			СчетаУчета.Добавить("РасчетыСКредиторамиОсновнойДолг");
			СчетаУчета.Добавить("РасчетыСКредиторамиПроценты");
			СчетаУчета.Добавить("РасчетыСКредиторамиКомиссия");
			СчетаУчета.Добавить("РасчетыСКлиентами");
			СчетаУчета.Добавить("РасчетыСПоставщиками");

			ТипыРасчетов = Новый Массив;
			ТипыРасчетов.Добавить("РасчетыСДебиторами");
			ТипыРасчетов.Добавить("РасчетыСКредиторами");
			ТипыРасчетов.Добавить("РасчетыСКлиентами");
			ТипыРасчетов.Добавить("РасчетыСПоставщиками");
			
			Для Каждого СтрокаПлатежа Из РеквизитыОбъекта.РасшифровкаПлатежа Цикл
				
				ЗаполнитьСчетаУчетаНаОснованииГФУ(СтрокаПлатежа, ГруппаФинансовогоУчета, СчетаУчета, ТипыРасчетов);
				
			КонецЦикла;
			
		КонецЕсли;
	
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику Тогда
		
		РеквизитыДоговора = Новый Структура;
		РеквизитыДоговора.Вставить("ВидВзаиморасчетов", "бг_ВидВзаиморасчетов");
		РеквизитыДоговора.Вставить("ГруппаФинансовогоУчета", "ГруппаФинансовогоУчета");
		
		Договор = Объект.Договор;
		Если Не ЗначениеЗаполнено(Договор) И ЗначениеЗаполнено(Объект.РасшифровкаПлатежа) Тогда
			ОбъектРасчетов = Объект.РасшифровкаПлатежа[0].ОбъектРасчетов;
			Если ЗначениеЗаполнено(ОбъектРасчетов) Тогда
				Договор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектРасчетов, "Договор");
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Договор) Тогда

			ЗначенияРеквизитовДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, РеквизитыДоговора);
			
			ВидВзаиморасчетовВДоговорахФакторинга =
				бг_КонстантыПовтИсп.ЗначениеКонстанты("ВидВзаиморасчетовВДоговорахФакторинга", Объект.Организация);
			
			ЗаполнитьСчетПоГФУДоговора = ЗначениеЗаполнено(ЗначенияРеквизитовДоговора.ГруппаФинансовогоУчета)
				И ЗначениеЗаполнено(ВидВзаиморасчетовВДоговорахФакторинга)
				И ЗначенияРеквизитовДоговора.ВидВзаиморасчетов = ВидВзаиморасчетовВДоговорахФакторинга;
				
			Если ЗаполнитьСчетПоГФУДоговора Тогда
				
				СчетаУчета = Новый Массив;
				СчетаУчета.Добавить("РасчетыСКлиентами");
				СчетаУчета.Добавить("РасчетыСПоставщиками");
				
				ТипыРасчетов = Новый Массив;
				ТипыРасчетов.Добавить("РасчетыСДебиторами");
				ТипыРасчетов.Добавить("РасчетыСКредиторами");
				ТипыРасчетов.Добавить("РасчетыСКлиентами");
				ТипыРасчетов.Добавить("РасчетыСПоставщиками");
				
				Для Каждого СтрокаПлатежа Из РеквизитыОбъекта.РасшифровкаПлатежа Цикл
					
					ЗаполнитьСчетаУчетаНаОснованииГФУ(
						СтрокаПлатежа,
						ЗначенияРеквизитовДоговора.ГруппаФинансовогоУчета,
						СчетаУчета, ТипыРасчетов);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // МетаданныеОбъекта
		"РасшифровкаПлатежа.СчетРасчетов",
		Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // МетаданныеОбъекта
		"РасшифровкаПлатежа.СчетРасчетовНУ",
		Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));

КонецПроцедуры

Процедура ДобавитьКлючевыеПоляКВыгрузке(РеквизитыИСвойства) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.ОбъектыРасчетов,
		"Договор",
		,
		Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.ОбъектыРасчетов,
		"Объект",
		,
		Метаданные.ОпределяемыеТипы.ОбъектРасчетов.Тип);
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.ДоговорыКредитовИДепозитов,
		"ГруппаФинансовогоУчета",
		,
		Новый ОписаниеТипов("СправочникСсылка.ГруппыФинансовогоУчетаРасчетов"));

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.ДоговорыКредитовИДепозитов,
		"Подразделение",
		,
		Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.БанковскиеСчетаОрганизаций,
		"Подразделение",
		,
		Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.ПервичныйДокумент,
		"Дата",,
		ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.ПервичныйДокумент,
		"Номер",,
		ОбщегоНазначения.ОписаниеТипаСтрока(30));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.ПервичныйДокумент,
		"ДатаВходящегоДокумента",,
		ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.ПервичныйДокумент,
		"НомерВходящегоДокумента",,
		ОбщегоНазначения.ОписаниеТипаСтрока(50));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Документы.ПервичныйДокумент,
		"ТипПервичногоДокумента",
		,
		Новый ОписаниеТипов("ПеречислениеСсылка.ТипыПервичныхДокументов"));
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.ПланыВидовХарактеристик.СтатьиДоходов,
		"ГруппаФинансовогоУчета",
		,
		Новый ОписаниеТипов("СправочникСсылка.ГруппыФинансовогоУчетаДоходовРасходов"));

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.ПланыВидовХарактеристик.СтатьиРасходов,
		"ГруппаФинансовогоУчетаРегл",
		,
		Новый ОписаниеТипов("СправочникСсылка.ГруппыФинансовогоУчетаДоходовРасходов"));

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.ПланыВидовХарактеристик.СтатьиРасходов,
		"ГруппаФинансовогоУчетаНУ",
		,
		Новый ОписаниеТипов("СправочникСсылка.ГруппыФинансовогоУчетаДоходовРасходов"));

	ДобавитьКлючевыеПоляНастройкиСчетовУчетаПрочихОпераций(РеквизитыИСвойства);
	
КонецПроцедуры

Процедура ДобавитьКлючевыеПоляНастройкиСчетовУчетаПрочихОпераций(РеквизитыИСвойства) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.НастройкиСчетовУчетаПрочихОпераций,
		"СчетУчета",
		,
		Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.ДоговорыАренды"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ДоговорыКонтрагентов"));
	МассивТипов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	МассивТипов.Добавить(Тип("СправочникСсылка.РегистрацииВНалоговомОргане"));
	МассивТипов.Добавить(Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ФизическиеЛица"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ИсполнительныйЛист"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств"));
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.ВидыНачисленийОплатыТрудаДляНУ"));
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.ВидыПлатежейВГосБюджет"));
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.ВидыРасчетовПоСредствамФСС"));
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.УровниБюджетов"));
	МассивТипов.Добавить(Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов"));
	МассивТипов.Добавить(Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов"));
	
	ОписаниеТиповСубконто = Новый ОписаниеТипов(МассивТипов);

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.НастройкиСчетовУчетаПрочихОпераций,
		"Субконто1",
		,
		ОписаниеТиповСубконто);

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.НастройкиСчетовУчетаПрочихОпераций,
		"Субконто2",
		,
		ОписаниеТиповСубконто);

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.НастройкиСчетовУчетаПрочихОпераций,
		"Субконто3",
		,
		ОписаниеТиповСубконто);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()

	ВыгружаемыеРеквизиты = Новый Массив;
	
	// Шапка
	ВыгружаемыеРеквизиты.Добавить("Дата");
	ВыгружаемыеРеквизиты.Добавить("Номер");
	ВыгружаемыеРеквизиты.Добавить("Проведен");
	ВыгружаемыеРеквизиты.Добавить("ПометкаУдаления");

	ВыгружаемыеРеквизиты.Добавить("Автор");
	ВыгружаемыеРеквизиты.Добавить("АналитикаАктивовПассивов");
	ВыгружаемыеРеквизиты.Добавить("АналитикаРасходов");
	ВыгружаемыеРеквизиты.Добавить("БанковскийСчет");
	ВыгружаемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
	ВыгружаемыеРеквизиты.Добавить("БанковскийСчетОтправитель");
	ВыгружаемыеРеквизиты.Добавить("Валюта");
	ВыгружаемыеРеквизиты.Добавить("ВалютаКонвертации");
	ВыгружаемыеРеквизиты.Добавить("ГруппаФинансовогоУчета");
	ВыгружаемыеРеквизиты.Добавить("ДанныеВыписки");
	ВыгружаемыеРеквизиты.Добавить("ДатаВходящегоДокумента");
	ВыгружаемыеРеквизиты.Добавить("ДатаВыгрузки");
	ВыгружаемыеРеквизиты.Добавить("ДатаЗагрузки");
	ВыгружаемыеРеквизиты.Добавить("ДатаПроведенияБанком");
	ВыгружаемыеРеквизиты.Добавить("Договор");
	ВыгружаемыеРеквизиты.Добавить("ДоговорЭквайринга");
	ВыгружаемыеРеквизиты.Добавить("ДокументВыдачи");
	ВыгружаемыеРеквизиты.Добавить("ДокументОснование");
	ВыгружаемыеРеквизиты.Добавить("ИдентификаторДокумента");
	ВыгружаемыеРеквизиты.Добавить("ИдентификаторПлатежа");
	ВыгружаемыеРеквизиты.Добавить("ИмяКонтрагента");
	ВыгружаемыеРеквизиты.Добавить("Исправление");
	ВыгружаемыеРеквизиты.Добавить("ИсправляемыйДокумент");
	ВыгружаемыеРеквизиты.Добавить("КассаОтправитель");
	ВыгружаемыеРеквизиты.Добавить("КодВалютнойОперации");
	ВыгружаемыеРеквизиты.Добавить("Комментарий");
	ВыгружаемыеРеквизиты.Добавить("Контрагент");
	ВыгружаемыеРеквизиты.Добавить("КратностьКурсаКонвертации");
	ВыгружаемыеРеквизиты.Добавить("КурсКонвертации");
	ВыгружаемыеРеквизиты.Добавить("НазначениеПлатежа");
	ВыгружаемыеРеквизиты.Добавить("НалогообложениеНДС");
	ВыгружаемыеРеквизиты.Добавить("НаправлениеДеятельности");
	ВыгружаемыеРеквизиты.Добавить("НомерВходящегоДокумента");
	ВыгружаемыеРеквизиты.Добавить("ОбъектРасчетов");
	ВыгружаемыеРеквизиты.Добавить("Организация");
	ВыгружаемыеРеквизиты.Добавить("Ответственный");
	ВыгружаемыеРеквизиты.Добавить("ОтражатьКомиссию");
	ВыгружаемыеРеквизиты.Добавить("ОшибкиЗагрузки");
	ВыгружаемыеРеквизиты.Добавить("Партнер");
	ВыгружаемыеРеквизиты.Добавить("ПодотчетноеЛицо");
	ВыгружаемыеРеквизиты.Добавить("Подразделение");
	ВыгружаемыеРеквизиты.Добавить("ПодтверждениеЗачисленияЗарплаты");
	ВыгружаемыеРеквизиты.Добавить("ПроведеноБанком");
	ВыгружаемыеРеквизиты.Добавить("ПроводкиПоРаботникам");
	ВыгружаемыеРеквизиты.Добавить("СтатьяАктивовПассивов");
	ВыгружаемыеРеквизиты.Добавить("СтатьяДвиженияДенежныхСредств");
	ВыгружаемыеРеквизиты.Добавить("СтатьяРасходов");
	ВыгружаемыеРеквизиты.Добавить("СторнируемыйДокумент");
	ВыгружаемыеРеквизиты.Добавить("СуммаДокумента");
	ВыгружаемыеРеквизиты.Добавить("СуммаКомиссии");
	ВыгружаемыеРеквизиты.Добавить("СуммаКонвертации");
	ВыгружаемыеРеквизиты.Добавить("ТипПлатежногоДокумента");
	ВыгружаемыеРеквизиты.Добавить("ФорматированноеНазначениеПлатежа");
	ВыгружаемыеРеквизиты.Добавить("ХозяйственнаяОперация");

	// РасшифровкаПлатежа
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.АналитикаАктивовПассивов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.АналитикаДоходов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ВалютаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ДоговорАренды");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ДоговорЗаймаСотруднику");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ДоговорКредитаДепозита");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ИдентификаторСтроки");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.КурсЗнаменательВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.КурсЧислительВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.НаправлениеДеятельности");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.НастройкаСчетовУчета");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ОбъектРасчетов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.Организация");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ОснованиеПлатежа");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.Партнер");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.Подразделение");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.РасчетныйДокументПоАренде");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтавкаНДС");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяДоходов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.Сумма");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.СуммаНДС");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ТипПлатежаПоАренде");
	ВыгружаемыеРеквизиты.Добавить("РасшифровкаПлатежа.ТипСуммыКредитаДепозита");
	
	Возврат ВыгружаемыеРеквизиты;

КонецФункции

Процедура ЗаполнитьСчетаУчетаНаОснованииГФУ(СтрокаПлатежа, ГруппаФинансовогоУчета, СчетаУчета, ТипыРасчетов = Неопределено, ТипСуммы = "")
	
	Перем адаптер_РаботаСДаннымиИБ;
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	Если ТипыРасчетов = Неопределено Тогда
		ТипыРасчетов = СчетаУчета;
	КонецЕсли;
	
	СтруктураЗначенийСчетаУчета = РегистрыСведений.ПорядокОтраженияНаСчетахУчета.СтруктураЗначенийПоАналитикеУчета(ГруппаФинансовогоУчета, СчетаУчета);
	СтруктураРеквизитовГФУ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ГруппаФинансовогоУчета, ТипыРасчетов);
	
	// ТипРасчетов
	Для каждого ТипРасчетов Из ТипыРасчетов Цикл
		Если СтруктураРеквизитовГФУ[ТипРасчетов] = Истина Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПолеСчетУчета = "СчетУчета_" + ТипРасчетов + ТипСуммы;
	
	// помещение счета учета в данные объекта
	Если СтруктураЗначенийСчетаУчета.Свойство(ПолеСчетУчета)
		И ЗначениеЗаполнено(СтруктураЗначенийСчетаУчета[ПолеСчетУчета]) Тогда
		
		адаптер_РаботаСДаннымиИБ.ЗаполнитьЗначениеРеквизита(СтрокаПлатежа, "СчетРасчетов_ЗначениеРеквизитаИдентификатор", 
		СтруктураЗначенийСчетаУчета[ПолеСчетУчета], Новый ТаблицаЗначений);
		СчетУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураЗначенийСчетаУчета[ПолеСчетУчета], "Код");
		СтрокаПлатежа.СчетРасчетов.Вставить("Код", СчетУчета);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
