#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ИнициализироватьДокумент();
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ДатаРасчета = ?(Корректировка, КорректируемыйПериод, Дата);
	Обработки.бг_АктуализацияДвиженийПоАкцизам.ВосстановитьПоследовательностьДвижений(
										АналитикиОтрицательныеОстаткиПоАкцизам(),
										ДатаРасчета,
										'00010101');
КонецПроцедуры

&После("ОбработкаУдаленияПроведения")
Процедура бг_ОбработкаУдаленияПроведения(Отказ)
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Обработки.бг_АктуализацияДвиженийПоАкцизам.ВосстановитьПоследовательностьДвижений(
										АналитикиОтрицательныеОстаткиПоАкцизам(),
										Дата,
										'00010101');
КонецПроцедуры

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	СуммаДокумента = Документы.битРасчетАвансовПоАкцизам.ПолучитьСуммуДокумента(ЭтотОбъект);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗаполнитьСостоянияОплатыРасчетовАванса();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция АналитикиОтрицательныеОстаткиПоАкцизам()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АкцизОстатки.Организация КАК Организация,
	|	АкцизОстатки.Номенклатура КАК Номенклатура,
	|	АкцизОстатки.СерияНоменклатуры КАК СерияНоменклатуры,
	|	АкцизОстатки.Сделка КАК Сделка,
	|	АкцизОстатки.СостояниеСырья КАК СостояниеСырья,
	|	АкцизОстатки.СостояниеОплатыАванса КАК СостояниеОплатыАванса,
	|	АкцизОстатки.СтатусАкциза КАК СтатусАкциза,
	|	АкцизОстатки.Продукция КАК Продукция,
	|	АкцизОстатки.СерияПродукции КАК СерияПродукции,
	|	АкцизОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.бг_АкцизПоПриобретеннымЦенностям.Остатки(, ) КАК АкцизОстатки
	|ГДЕ
	|	АкцизОстатки.КоличествоОстаток < 0";
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить();
КонецФункции

Процедура ИнициализироватьДокумент()
	Автор = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ЗаполнитьСостоянияОплатыРасчетовАванса()
	КэшСостоянияОплаты = Новый ТаблицаЗначений;
	КэшСостоянияОплаты.Колонки.Добавить("НалоговаяСтавка", ОбщегоНазначения.ОписаниеТипаЧисло(6));
	КэшСостоянияОплаты.Колонки.Добавить("ПродажаНаЭкспорт", Новый ОписаниеТипов("Булево"));
	КэшСостоянияОплаты.Колонки.Добавить("Период", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	КэшСостоянияОплаты.Колонки.Добавить("СостояниеОплатыАванса", Новый ОписаниеТипов("СправочникСсылка.бг_СостоянияОплатыАванса"));
	
	Если ХозяйственнаяОперация = Перечисления.бг_ОперацииРасчетаАвансовПоАкцизам.РасчетАвансов Тогда
		СтатусНачисления = Перечисления.бг_СтатусыНачисленияАвансов.НачисленАванс;
	Иначе
		СтатусНачисления = Перечисления.бг_СтатусыНачисленияАвансов.ОформленВычет;
	КонецЕсли;
	
	Для Каждого СтрокаАкциз Из Акцизы Цикл
		Если ХозяйственнаяОперация = Перечисления.бг_ОперацииРасчетаАвансовПоАкцизам.РасчетАвансов Тогда
			СтрокаАкциз.ПериодНачисленияАванса = ?(Корректировка, КорректируемыйПериод, Дата);;
		КонецЕсли;
		
		СостояниеОплаты = СостояниеОплаты(КэшСостоянияОплаты, СтатусНачисления,
						СтрокаАкциз.НалоговаяСтавка, СтрокаАкциз.ПродажаНаЭкспорт, СтрокаАкциз.ПериодНачисленияАванса);
		СтрокаАкциз.СостояниеОплатыАванса = СостояниеОплаты;
	КонецЦикла;
КонецПроцедуры

Функция СостояниеОплаты(КэшСостоянияОплаты, СтатусНачисления, НалоговаяСтавка, ПродажаНаЭкспорт, Период)
	Отбор = Новый Структура("НалоговаяСтавка, ПродажаНаЭкспорт, Период", НалоговаяСтавка, ПродажаНаЭкспорт, Период);
	
	СтрокиКэш = КэшСостоянияОплаты.НайтиСтроки(Отбор);
	Если СтрокиКэш.Количество() > 0 Тогда
		Возврат СтрокиКэш[0].СостояниеОплатыАванса;
	КонецЕсли;
	
	СостояниеОплаты = Справочники.бг_СостоянияОплатыАванса.СостояниеОплатыАванса(Период, СтатусНачисления, НалоговаяСтавка, ПродажаНаЭкспорт);
	
	НоваяСтрокаКэш = КэшСостоянияОплаты.Добавить();
	НоваяСтрокаКэш.НалоговаяСтавка       = НалоговаяСтавка;
	НоваяСтрокаКэш.ПродажаНаЭкспорт      = ПродажаНаЭкспорт;
	НоваяСтрокаКэш.Период                = Период;
	НоваяСтрокаКэш.СостояниеОплатыАванса = СостояниеОплаты;
	
	Возврат СостояниеОплаты;
КонецФункции

#КонецОбласти

#КонецЕсли
