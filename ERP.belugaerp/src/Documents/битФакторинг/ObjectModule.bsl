#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.бг_ВидыОперацийФакторинга.ФинансированиеФактором Тогда
		СуммаДокумента = ДокументыРеализации.Итог("СуммаФинансирования");
	ИначеЕсли ВидОперации = Перечисления.бг_ВидыОперацийФакторинга.ПереводОстаткаФактором Тогда
		СуммаДокумента = ДокументыРеализации.Итог("Остаток");
	ИначеЕсли ВидОперации = Перечисления.бг_ВидыОперацийФакторинга.ВознаграждениеФактора Тогда
		СуммаДокумента = ДокументыРеализации.Итог("Комиссия1") + ДокументыРеализации.Итог("Комиссия2")
			+ ДокументыРеализации.Итог("Комиссия3");
	Иначе
		СуммаДокумента = ДокументыРеализации.Итог("Сумма");
	КонецЕсли;
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

&После("ОбработкаПроверкиЗаполнения")
Процедура бг_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Не ВидОперации = Перечисления.бг_ВидыОперацийФакторинга.ПередачаДокументовФакторуНаФинансирование
		И Не ВидОперации = Перечисления.бг_ВидыОперацийФакторинга.ПередачаДокументовФакторуПодПлатеж Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
		
	КонецЕсли;
	
	ОперацииВзаимодействияСКорСтатьей = Новый Массив;
	ОперацииВзаимодействияСКорСтатьей.Добавить(
		Перечисления.бг_ВидыОперацийФакторинга.ПередачаДокументовФакторуНаФинансирование);
	ОперацииВзаимодействияСКорСтатьей.Добавить(
		Перечисления.бг_ВидыОперацийФакторинга.ПередачаДокументовФакторуПодПлатеж);
	ОперацииВзаимодействияСКорСтатьей.Добавить(
		Перечисления.бг_ВидыОперацийФакторинга.ОплатаДебитораНам);
	ОперацииВзаимодействияСКорСтатьей.Добавить(
		Перечисления.бг_ВидыОперацийФакторинга.ОплатаДебиторомФактору);
	Если ОперацииВзаимодействияСКорСтатьей.Найти(ВидОперации) = Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КорСтатьяАктивовЗадолженностьКлиентов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.битФакторинг") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДД.ВидОперации КАК ВидОперации,
		|	ДД.Организация КАК Организация,
		|	ДД.Фактор КАК Фактор,
		|	ДД.ДоговорФактора КАК ДоговорФактора,
		|	ДД.Подразделение КАК Подразделение,
		|	ДД.СтавкаНДС КАК СтавкаНДС,
		|	ДД.СуммаВключаетНДС КАК СуммаВключаетНДС,
		|	ДД.СтатьяДоходов КАК СтатьяДоходов,
		|	ДД.СтатьяРасходов КАК СтатьяРасходов,
		|	ДД.КорСтатьяАктивовЗадолженностьКлиентов КАК КорСтатьяАктивовЗадолженностьКлиентов,
		|	ДД.ГруппаФинансовогоУчетаКонтрагента КАК ГруппаФинансовогоУчетаКонтрагента
		|ИЗ
		|	Документ.битФакторинг КАК ДД
		|ГДЕ
		|	ДД.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
	Если ВидОперации = Перечисления.бг_ВидыОперацийФакторинга.ОплатаДебиторомФактору
		И Не ЗначениеЗаполнено(СтавкаНДС) Тогда
		СтавкаНДС = УчетНДСУП.СтавкаНДСПоУмолчанию(Организация, Дата);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&После("ОбработкаУдаленияПроведения")
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	ЗаполнитьПоляПоУмолчанию();
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ЗаполнитьПоляПоУмолчанию()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДД.Ссылка КАК Ссылка,
	|	ДД.КорСтатьяАктивовЗадолженностьКлиентов КАК КорСтатьяАктивовЗадолженностьКлиентов
	|ИЗ
	|	Документ.битФакторинг КАК ДД
	|ГДЕ
	|	ДД.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДД.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, "КорСтатьяАктивовЗадолженностьКлиентов");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли