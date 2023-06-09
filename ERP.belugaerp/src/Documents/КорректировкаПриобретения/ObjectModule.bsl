#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	бг_УстановитьДатуОплатыМагистраль(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

&После("ЗаполнитьПоПоступлениюТоваровУслуг")
Процедура бг_ЗаполнитьПоПоступлениюТоваровУслуг(Знач ДокументОснование, ДанныеЗаполнения)
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСвязанныхТТН = Документы.ТТНВходящаяЕГАИС.бг_ДанныеТТНВходящихПоСвязанномуДокументу(
		ДанныеЗаполнения.ДокументОснование);
		
	Если ДанныеСвязанныхТТН <> Неопределено Тогда
		ДанныеПроведенныхСвязанныхТТН = ДанныеСвязанныхТТН.Скопировать(
			ДанныеСвязанныхТТН.НайтиСтроки(
				Новый Структура("Проведен", Истина)));
	КонецЕсли;
	
	Если ДанныеПроведенныхСвязанныхТТН <> Неопределено И ДанныеПроведенныхСвязанныхТТН.Количество() <> 0 Тогда
		
		ПараметрыЗаполнения = бг_ПараметрыЗаполненияКорректировкиПоТТНВходящая(ДанныеЗаполнения);
		
		ДанныеПоследнегоДокумента = ДанныеПроведенныхСвязанныхТТН[0];
		
		ПараметрыЗаполнения.НомерВходящегоДокумента = ДанныеПоследнегоДокумента.НомерТТН;
		ПараметрыЗаполнения.ДатаВходящегоДокумента = ДанныеПоследнегоДокумента.ДатаТТН;
		
		ПараметрыЗаполнения.СвязанныеДокументыТТН = ДанныеПроведенныхСвязанныхТТН.ВыгрузитьКолонку("Документ");
		
		бг_ЗаполнитьПоТТНВходящая(ПараметрыЗаполнения);
		
		бг_ЗаполнитьОтветственныхЛицОрганизации();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ЗаполнитьПоТТНВходящая(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект, 
		ДанныеЗаполнения, 
		"ВидКорректировки,НомерВходящегоДокумента,ДатаВходящегоДокумента,ДокументОснование,Склад,НалогообложениеНДС,ЦенаВключаетНДС");
	
	ПараметрыУказанияСерий = Документы.КорректировкаПриобретения.ПараметрыУказанияСерий(ЭтотОбъект);
	
	бг_ЗаполнитьТоварыПоДаннымТТН(ДанныеЗаполнения, ПараметрыУказанияСерий);
	
	ИспользуетсяДокументПоступлениеТоваров = бг_ИспользуетсяДокументПоступлениеТоваров(ДанныеЗаполнения.ОперацияОснования);
	
	ЗаполнитьРасхождения(ИспользуетсяДокументПоступлениеТоваров);
	бг_ЗаполнитьВариантыОтраженияКорректировки(ИспользуетсяДокументПоступлениеТоваров);
	
	ПараметрыУказанияСерий.ИмяТЧТовары = "Расхождения";
	ПараметрыУказанияСерий.ИмяТЧСерии  = "Расхождения";
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

Процедура бг_ЗаполнитьТоварыПоДаннымТТН(ДанныеЗаполнения, ПараметрыУказанияСерий)
	
	СвязанныеДокументыТТН = ДанныеЗаполнения.СвязанныеДокументыТТН; 
	
	ТаблицаТовары = Товары.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.Склад КАК Склад,
	|	ТаблицаТовары.Упаковка КАК Упаковка,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТовары.КодСтроки КАК КодСтроки,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.Содержание КАК Содержание,
	|	ТаблицаТовары.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТовары.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТовары.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ТаблицаТовары.НомерГТД КАК НомерГТД,
	|	ТаблицаТовары.Сделка КАК Сделка,
	|	ТаблицаТовары.Подразделение КАК Подразделение,
	|	ТаблицаТовары.НомерГруппыЗатрат КАК НомерГруппыЗатрат,
	|	ТаблицаТовары.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	ТаблицаТовары.ЭтапПроизводства КАК ЭтапПроизводства,
	|	ТаблицаТовары.СписатьНаРасходы КАК СписатьНаРасходы,
	|	ТаблицаТовары.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаТовары.АналитикаРасходов КАК АналитикаРасходов,
	|	ТаблицаТовары.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаТовары.НастройкаСчетовУчета КАК НастройкаСчетовУчета,
	|	ТаблицаТовары.АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
	|	ТаблицаТовары.АналитикаДоходов КАК АналитикаДоходов
	|ПОМЕСТИТЬ ИсходнаяТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходнаяТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ИсходнаяТаблицаТовары.Характеристика КАК Характеристика,
	|	ИсходнаяТаблицаТовары.Серия КАК Серия,
	|	ИсходнаяТаблицаТовары.Склад КАК Склад,
	|	ИсходнаяТаблицаТовары.Упаковка КАК Упаковка,
	|	ИсходнаяТаблицаТовары.КодСтроки КАК КодСтроки,
	|	ИсходнаяТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ИсходнаяТаблицаТовары.Назначение КАК Назначение,
	|	ИсходнаяТаблицаТовары.Содержание КАК Содержание,
	|	СУММА(ИсходнаяТаблицаТовары.КоличествоПоРНПТ) КАК КоличествоПоРНПТ,
	|	СУММА(ИсходнаяТаблицаТовары.СуммаНДС) КАК СуммаНДС,
	|	СУММА(ИсходнаяТаблицаТовары.СуммаСНДС) КАК СуммаСНДС,
	|	ИсходнаяТаблицаТовары.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ИсходнаяТаблицаТовары.НомерГТД КАК НомерГТД,
	|	ИсходнаяТаблицаТовары.Сделка КАК Сделка,
	|	ИсходнаяТаблицаТовары.Подразделение КАК Подразделение,
	|	ИсходнаяТаблицаТовары.НомерГруппыЗатрат КАК НомерГруппыЗатрат,
	|	ИсходнаяТаблицаТовары.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	ИсходнаяТаблицаТовары.ЭтапПроизводства КАК ЭтапПроизводства,
	|	ИсходнаяТаблицаТовары.СписатьНаРасходы КАК СписатьНаРасходы,
	|	ИсходнаяТаблицаТовары.СтатьяРасходов КАК СтатьяРасходов,
	|	ИсходнаяТаблицаТовары.АналитикаРасходов КАК АналитикаРасходов,
	|	ИсходнаяТаблицаТовары.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ИсходнаяТаблицаТовары.НастройкаСчетовУчета КАК НастройкаСчетовУчета,
	|	ИсходнаяТаблицаТовары.АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
	|	ИсходнаяТаблицаТовары.АналитикаДоходов КАК АналитикаДоходов
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	ИсходнаяТаблицаТовары КАК ИсходнаяТаблицаТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсходнаяТаблицаТовары.Номенклатура,
	|	ИсходнаяТаблицаТовары.Характеристика,
	|	ИсходнаяТаблицаТовары.Назначение,
	|	ИсходнаяТаблицаТовары.Серия,
	|	ИсходнаяТаблицаТовары.Содержание,
	|	ИсходнаяТаблицаТовары.Упаковка,
	|	ИсходнаяТаблицаТовары.КодСтроки,
	|	ИсходнаяТаблицаТовары.ЗаказПоставщику,
	|	ИсходнаяТаблицаТовары.Склад,
	|	ИсходнаяТаблицаТовары.Сделка,
	|	ИсходнаяТаблицаТовары.Подразделение,
	|	ИсходнаяТаблицаТовары.НомерГруппыЗатрат,
	|	ИсходнаяТаблицаТовары.СтатьяКалькуляции,
	|	ИсходнаяТаблицаТовары.ЭтапПроизводства,
	|	ИсходнаяТаблицаТовары.СписатьНаРасходы,
	|	ИсходнаяТаблицаТовары.СтатьяРасходов,
	|	ИсходнаяТаблицаТовары.АналитикаРасходов,
	|	ИсходнаяТаблицаТовары.АналитикаАктивовПассивов,
	|	ИсходнаяТаблицаТовары.АналитикаДоходов,
	|	ИсходнаяТаблицаТовары.НаправлениеДеятельности,
	|	ИсходнаяТаблицаТовары.НастройкаСчетовУчета,
	|	ИсходнаяТаблицаТовары.НомерГТД,
	|	ИсходнаяТаблицаТовары.СтавкаНДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТТНВходящаяЕГАИСТовары.Номенклатура КАК Номенклатура,
	|	ТТНВходящаяЕГАИСТовары.Характеристика КАК Характеристика,
	|	ТТНВходящаяЕГАИСТовары.Серия КАК Серия,
	|	СУММА(ТТНВходящаяЕГАИСТовары.КоличествоФакт) КАК Количество,
	|	СУММА(ТТНВходящаяЕГАИСТовары.КоличествоФакт) КАК КоличествоУпаковок,
	|	ТТНВходящаяЕГАИСТовары.Цена КАК Цена,
	|	&Склад КАК Склад,
	|	ТТНВходящаяЕГАИСТовары.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ТТНВходящаяЕГАИСТовары.Номенклатура.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ТоварыТТН
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИСТовары
	|ГДЕ
	|	ТТНВходящаяЕГАИСТовары.Ссылка В(&Источники)
	|	И ТТНВходящаяЕГАИСТовары.КоличествоФакт <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТТНВходящаяЕГАИСТовары.Номенклатура,
	|	ТТНВходящаяЕГАИСТовары.Характеристика,
	|	ТТНВходящаяЕГАИСТовары.Серия,
	|	ТТНВходящаяЕГАИСТовары.Цена,
	|	ТТНВходящаяЕГАИСТовары.Номенклатура.ЕдиницаИзмерения,
	|	ТТНВходящаяЕГАИСТовары.Номенклатура.СтавкаНДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыТТН.Номенклатура КАК Номенклатура,
	|	ТоварыТТН.Характеристика КАК Характеристика,
	|	ТоварыТТН.Серия КАК Серия,
	|	ТоварыТТН.Количество КАК Количество,
	|	ТоварыТТН.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТоварыТТН.Цена КАК Цена,
	|	ЕСТЬNULL(ТаблицаТовары.Склад, ТоварыТТН.Склад) КАК Склад,
	|	ЕСТЬNULL(ТаблицаТовары.Упаковка, ТоварыТТН.Упаковка) КАК Упаковка,
	|	ЕСТЬNULL(ТаблицаТовары.СтавкаНДС, ТоварыТТН.СтавкаНДС) КАК СтавкаНДС,
	|	ТаблицаТовары.Назначение КАК Назначение,
	|	ТаблицаТовары.Содержание КАК Содержание,
	|	ТаблицаТовары.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТовары.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТовары.КодСтроки КАК КодСтроки,
	|	ТаблицаТовары.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ТаблицаТовары.НомерГТД КАК НомерГТД,
	|	ТаблицаТовары.Сделка КАК Сделка,
	|	ТаблицаТовары.Подразделение КАК Подразделение,
	|	ТаблицаТовары.НомерГруппыЗатрат КАК НомерГруппыЗатрат,
	|	ТаблицаТовары.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	ТаблицаТовары.ЭтапПроизводства КАК ЭтапПроизводства,
	|	ТаблицаТовары.СписатьНаРасходы КАК СписатьНаРасходы,
	|	ТаблицаТовары.СтатьяРасходов КАК СтатьяРасходов,
	|	ТаблицаТовары.АналитикаРасходов КАК АналитикаРасходов,
	|	ТаблицаТовары.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаТовары.НастройкаСчетовУчета КАК НастройкаСчетовУчета,
	|	ТаблицаТовары.АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
	|	ТаблицаТовары.АналитикаДоходов КАК АналитикаДоходов
	|ИЗ
	|	ТоварыТТН КАК ТоварыТТН
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаТовары КАК ТаблицаТовары
	|		ПО ТоварыТТН.Номенклатура = ТаблицаТовары.Номенклатура
	|			И ТоварыТТН.Характеристика = ТаблицаТовары.Характеристика
	|			И ТоварыТТН.Серия = ТаблицаТовары.Серия";
	
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТовары);
	Запрос.УстановитьПараметр("Источники", СвязанныеДокументыТТН);
	Запрос.УстановитьПараметр("Склад", ДанныеЗаполнения.Склад);
	
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧ, СтруктураДействий, Неопределено);
	КонецЦикла;
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры	

#КонецОбласти

#Область Прочее

Процедура бг_ЗаполнитьОтветственныхЛицОрганизации()

	ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Организация);

	ОтветственныеЛица.Свойство("РуководительСсылка", бг_Руководитель);
	ОтветственныеЛица.Свойство("ГлавныйБухгалтерСсылка", бг_ГлавныйБухгалтер);
	
КонецПроцедуры	

Процедура бг_УстановитьДатуОплатыМагистраль(ДанныеЗаполнения)
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения.ДокументОснование)
		Или ТипЗнч(ДанныеЗаполнения.ДокументОснование) <> Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения.ДокументОснование,
		"Дата, бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС");
	
	Если РеквизитыОснования.бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС = Истина Тогда
		ДатаПлатежа = бг_Магистраль.ДатаПлатежа(РеквизитыОснования.Дата,
			ДанныеЗаполнения.Договор, ДанныеЗаполнения.Соглашение);
	КонецЕсли;
	
КонецПроцедуры

Функция бг_ПараметрыЗаполненияКорректировкиПоТТНВходящая(ДанныеЗаполнения)
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВидКорректировки", 			Перечисления.ХозяйственныеОперации.КорректировкаПоСогласованиюСторон);
	Параметры.Вставить("НомерВходящегоДокумента", 	"");
	Параметры.Вставить("ДатаВходящегоДокумента", 	Дата(1,1,1));
	Параметры.Вставить("Склад", 					ДанныеЗаполнения.Склад);
	Параметры.Вставить("ДокументОснование",			ДанныеЗаполнения.ДокументОснование);
	Параметры.Вставить("ОперацияОснования", 		ДанныеЗаполнения.ХозяйственнаяОперацияОснования);
	Параметры.Вставить("НалогообложениеНДС",		ДанныеЗаполнения.НалогообложениеНДС);
	Параметры.Вставить("ЦенаВключаетНДС",			ДанныеЗаполнения.ЦенаВключаетНДС);
	Параметры.Вставить("СвязанныеДокументыТТН", 	Новый Массив); 
	
	Возврат Параметры;
	
КонецФункции	

Функция бг_ИспользуетсяДокументПоступлениеТоваров(ОперацияОснования)
	
	ИспользуетсяДокументПоступлениеТоваров = Ложь;
	
	Если ЗначениеЗаполнено(ОперацияОснования) Тогда
		
		ОперацииРаздельнойЗакупки = Новый Массив;
		ОперацииРаздельнойЗакупки.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути);
		ОперацииРаздельнойЗакупки.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки);
		ОперацииРаздельнойЗакупки.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути);
		ОперацииРаздельнойЗакупки.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки);
		ОперацииРаздельнойЗакупки.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути);
		
		ИспользуетсяДокументПоступлениеТоваров = ОперацииРаздельнойЗакупки.Найти(ОперацияОснования) <> Неопределено;
	КонецЕсли;
	
	Возврат ИспользуетсяДокументПоступлениеТоваров;
	
КонецФункции

Процедура бг_ЗаполнитьВариантыОтраженияКорректировки(ИспользуетсяДокументПоступлениеТоваров)
	
	ДанныеПоСкладам = бг_ДанныеПоСкладамРасхождений();
	
	Для Каждого СтрокаРасхождений Из Расхождения Цикл
		
		Если СтрокаРасхождений.КоличествоУпаковок < 0 Тогда
			
			ДанныеПоСкладу = ДанныеПоСкладам.Найти(СтрокаРасхождений.Склад, "Склад");
			
			Если ДанныеПоСкладу = Неопределено 
				Или Не ДанныеПоСкладу.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда
				Продолжить;	
			КонецЕсли;	
			
			СтрокаРасхождений.ВариантОтражения = ?(
				ИспользуетсяДокументПоступлениеТоваров, 
				Перечисления.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУменьшитьТоварыУПартнеров, 
				Перечисления.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУчестьПриИнвентаризации);
	
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры	

Функция бг_ДанныеПоСкладамРасхождений()
	
	СкладыРасхождений = Расхождения.Выгрузить(, "Склад");
	СкладыРасхождений.Свернуть("Склад");
	
	СкладыРасхождений.Колонки.Добавить(
		"ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач",
		Новый ОписаниеТипов("Булево"));
	
	Для Каждого Строка Из СкладыРасхождений Цикл
			
		Если ЗначениеЗаполнено(Строка.Склад) Тогда
			
			Строка.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(
				Строка.Склад, 
				Дата);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СкладыРасхождений;
	
КонецФункции

&После("ЗаполнитьРасхождения")
Процедура бг_ЗаполнитьРасхождения(ИспользуетсяДокументПоступлениеТоваров)

	Для Каждого Расхождение Из Расхождения Цикл
		
		Расхождение.бг_КоличествоНедостача = ?(Расхождение.КоличествоУпаковок < 0, -Расхождение.КоличествоУпаковок, 0);
		Расхождение.бг_КоличествоИзлишек   = ?(Расхождение.КоличествоУпаковок > 0, Расхождение.КоличествоУпаковок, 0);
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
